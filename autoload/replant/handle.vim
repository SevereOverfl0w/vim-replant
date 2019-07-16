fun! replant#handle#quickfix_find_symbol(msgs)
  let qfs = []
  for msg in a:msgs
    if has_key(msg, 'occurrence')
      let occurrence = msg['occurrence']
      let d = {}
      let d.filename = fnamemodify(occurrence.file, ':~:.')
      let d.lnum = occurrence['line-beg']
      let d.col = occurrence['col-beg']
      let d.text = occurrence['match']
      call add(qfs, d)
    elseif has_key(msg, 'error')
      echo msg['error']
      return 0
    endif
  endfor
  return qfs
endf

fun! replant#handle#hotload(cmsg)
  if has_key(a:cmsg, 'dependency')
    echo 'Hotloaded '.a:cmsg.dependency
  endif
  if has_key(a:cmsg, 'error')
    echo a:cmsg.error
  endif
endf

fun! replant#handle#stacktrace_qf(qfs, stacktraces)
  for stacktrace in a:stacktraces
    let d = {}
    let d.lnum = stacktrace['line']
    let d.text = stacktrace['name']


    if has_key(stacktrace, 'file-url') && type(stacktrace['file-url']) == v:t_string
      let file = replant#url_to_vim(stacktrace['file-url'])
      let d.filename = fnamemodify(file, ':.')
    else
      " Emacs-ism, ugh. It returns [] for "nil", like, wtf?
      let f = get(stacktrace, 'file')
      if type(f) == v:t_string
        let d.text = '['.f.'] '.d.text
      endif
    endif

    let d.text .= ' '.join(map(stacktrace['flags'], {idx, val -> '#'.val}), ' ')
    call add(a:qfs, d)
  endfor
endf

fun! replant#handle#insert_top_level_messages(qfs, errors)
  for e in a:errors
    let d = {}

    if has_key(e, 'file-url') && type(e['file-url']) == v:t_string
      let d.filename = replant#url_to_vim(e['file-url'])
    endif

    if has_key(e, 'line')
      let d.lnum = e.line
    endif

    if has_key(e, 'column')
      let d.col = e.column
    endif

    if has_key(e, 'class') && type(e.message) == v:t_string
      let d.text = e.class . ': '
    endif

    if has_key(e, 'message') && type(e.message) == v:t_string
      let d.text .= e['message']
    endif

    call insert(a:qfs, d)
  endfor
endf

fun! replant#handle#quickfix_resources_list(msgs)
  let msg = a:msgs[0]
  let qfs = []

  for resource in get(msg, 'resources-list', [])
    let d = {}

    let d.filename = fnamemodify(resource.file, ':~:.')
    let d.text = resource.relpath

    call add(qfs, d)
  endfor

  return qfs
endf

fun! replant#handle#find_test_results_msg(msgs)
  for x in a:msgs
    if has_key(x, 'results')
      return x
    endif
  endfor
endf

fun! replant#handle#test_summary(msgs)
  let result_msg = replant#handle#find_test_results_msg(a:msgs)
  let summary = get(result_msg, 'summary', {})

  echo 'Tested '.get(summary, 'ns').' namespaces'
  echo 'Ran '.get(summary, 'test').' assertions, in '.get(summary, 'var').' test functions'

  if get(summary, 'fail')
    echohl WarningMsg
    echo get(summary, 'fail').' failures'
  endif

  if get(summary, 'error')
    echohl ErrorMsg
    echo get(summary, 'error').' errors'
  endif

  echohl DiffAdd
  echo get(summary, 'pass').' passed'

  echohl None
endf

fun! replant#handle#test_add_to_qf(qfs, msgs)
  let result_msg = replant#handle#find_test_results_msg(a:msgs)
  let results = get(result_msg, 'results', {})

  let qfs = a:qfs

  for [ns, vars] in items(results)
    for [var, assertions] in items(vars)
      for assertion in assertions
        if get(assertion, 'type') != 'pass'

          let Add_text = {text -> add(qfs, {'text': text})}

          let qf = {}

          let qf['text'] = get(assertion, 'ns').'/'.get(assertion, 'var')
          let qf['lnum'] = get(assertion, 'line')
          let qf['nr'] = get(assertion, 'index')

          if has_key(assertion, 'file-url') && type(assertion['file-url']) == v:t_string
            let qf.filename = replant#url_to_vim(assertion['file-url'])
          endif

          if get(assertion, 'type') == 'error'
            let qf['type'] = 'E'
          elseif get(assertion, 'type') == 'fail'
            let qf['type'] = 'W'
          endif

          call add(qfs, qf)

          if has_key(assertion, 'context') && type(assertion['context']) == v:t_string
            call Add_text('Testing '.assertion['context'])
          endif

          if has_key(assertion, 'expected')
            call Add_text('expected')
            call Add_text(get(assertion, 'expected'))
          endif

          if get(assertion, 'diffs', []) != []
            let diffs = get(assertion, 'diffs')
            for [actual, change] in diffs
              let [removed, added] = change
              call Add_text('actual')
              call Add_text(actual)
              call Add_text('diff')
              call Add_text('- '.removed)
              call Add_text('+ '.added)
            endfor
          else
            if has_key(assertion, 'actual') && type(assertion['actual']) == v:t_string
              call Add_text('actual')
              call Add_text(assertion['actual'])
            endif
          endif

          if has_key(assertion, 'error')
            call Add_text('exception message')
            call Add_text(get(assertion, 'error'))

            call Add_text('To inspect stacktrace, run: :ReplantTestStacktrace '.get(assertion, 'ns').' '.get(assertion, 'var').' '.get(assertion, 'index'))
          endif

          if has_key(assertion, 'gen-input')
            call Add_text('input')
            call Add_text(get(assertion, 'gen-input'))
          endif
        endif
      endfor
    endfor
  endfor
endf

fun! replant#handle#test_fix_file(info_msgs, msgs)
  let result_msg = replant#handle#find_test_results_msg(a:msgs)
  let results = get(result_msg, 'results', {})

  for infos in a:info_msgs
    for info in infos
      if has_key(info, 'file')
        for assertion in results[info['ns']][info['name']]
          let assertion['file-url'] = info['file']
        endfor
      endif
    endfor
  endfor
endf

fun! replant#handle#is_tests_pass(msgs)
  let result_msg = replant#handle#find_test_results_msg(a:msgs)
  let summary = get(result_msg, 'summary', {})

  return (get(summary, 'fail') + get(summary, 'error')) == 0
endf

fun! replant#handle#apropos_fzf(msgs)
  let result = a:msgs[0]
  let apropos_matches = get(result, 'apropos-matches', [])

  let resources = []
  
  for m in apropos_matches 
    let resources += [m['name'].':', '', '  '.m['doc']]
  endfor

  let actions = {'ctrl-x': ['jump', 'split'],
               \ 'ctrl-v': ['jump', 'vertical split'],
               \ 'ctrl-t': ['jump', 'tabe'],
               \ 'ctrl-i': ['doc', ''],
               \ 'ctrl-y': ['test', '']}

  let Resolver = {a -> get(actions, a, ['jump', 'edit'])}

  let file = tempname()
  let preview_command = 'grep -a -A 2 {}: '.file.' | xargs --null printf "%s\n"'
  call writefile(resources, file)
  let opts = {'source': map(apropos_matches, {idx, x -> x['name']}),
            \ 'sink*': function('replant#fzf#symbol_jump', [Resolver]),
            \ 'options': "--expect=ctrl-t,ctrl-v,ctrl-x,ctrl-i,ctrl-y --multi --tiebreak=index --color --preview-window wrap --preview '".preview_command."'"}
  call fzf#run(fzf#wrap(opts))
endf

fun! replant#handle#info_jump_to_source(edit_cmd, msgs)
  let info = a:msgs[0]

  if replant#util#contains(info['status'], 'no-info')
    echoerr 'No info found'
    return
  endif

  let file = replant#url_to_vim(info['file'])
  let line = info['line']
  let column = get(info, 'column', 0)

  execute ':'.a:edit_cmd.' +call\ cursor('.line.','.column.') '.file
endf

fun! replant#handle#clean_ns(msg)
  if has_key(a:msg, 'ns') && type(a:msg['ns']) != v:t_list
    call replant#util#replace_ns(split(a:msg.ns, '\n'))
  endif
endf

fun! replant#handle#read_source(msgs)
  let out = ''
  for msg in a:msgs
      if has_key(msg, 'out')
          let out = msg.out
          break
      endif
  endfor

  return out
endf
