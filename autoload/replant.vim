fun! replant#user_eval(code)
  let mc = replant#message#send_collect({'op': 'eval', 'code': a:code})
  if has_key(mc, "out")
    echo mc["out"]
    echo "---"
  endif
  echo mc["value"]

  return mc
endf

fun! replant#doc_msg(ns, symbol)
  return {'op': 'info', 'symbol': a:symbol, 'ns': a:ns}
endf

fun! s:contains(ls, v)
  for item in a:ls
    if a:v == item
      return 1
    endif
  endfor

  return 0
endf

fun! replant#doc(doc_mc)
  if s:contains(a:doc_mc['status'], 'no-info')
    echohl Error
    echo "No doc found"
    echohl Normal
    return
  endif
  if get(a:doc_mc, 'macro') is 'true'
    echohl Macro
  elseif get(a:doc_mc, 'special-form') is 'true'
    echohl Special
  elseif has_key(a:doc_mc, 'arglists-str')
    echohl Function
  elseif has_key(a:doc_mc, 'class')
    echohl StorageClass
  elseif has_key(a:doc_mc, 'ns') && !has_key(a:doc_mc, 'name')
    " A namespace
    echohl Macro
  else
    echohl Error
  endif

  let clj_name = ""
  if has_key(a:doc_mc, 'ns')
    if !has_key(a:doc_mc, 'name')
      echo get(a:doc_mc, 'ns')
    else
      let clj_name = get(a:doc_mc, 'ns').'/'.get(a:doc_mc, 'name')
    endif
  else
    let clj_name = get(a:doc_mc, 'name')
  endif

  let java_name = ""
  if has_key(a:doc_mc, 'member')
    let java_name = get(a:doc_mc, 'class').'/'.a:doc_mc['member']
  else
    let java_name = get(a:doc_mc, 'class')
  endif

  if has_key(a:doc_mc, 'class')
    echo java_name
  else
    echo clj_name
  endif

  echohl Normal

  if has_key(a:doc_mc, 'super')
    echo '    Extends: '.a:doc_mc['super']
  endif

  if has_key(a:doc_mc, 'interfaces')
    let l:line_prefix = '    Implements: '
    let l:subline_prefix = repeat(' ', strlen(l:line_prefix))
    echo l:line_prefix.a:doc_mc['interfaces'][0]
    echo l:subline_prefix.join(a:doc_mc['interfaces'][1:], "\n".l:subline_prefix)
  endif

  let l:forms = split(get(a:doc_mc, 'forms-str', get(a:doc_mc, 'arglists-str', '')), "\n")

  for f in l:forms
    echo " ".f
  endfor

  echohl Normal
  let var_type = [['macro', 'Macro'], ['special', 'Special Form']]
  for [k, v] in var_type
    if get(a:doc_mc, k) == v:true
      echo v
    endif
  endfor

  if has_key(a:doc_mc, 'added')
    echohl Comment
    echo 'Added in '. get(a:doc_mc, 'added', 'Oops, added broke')
  endif

  if has_key(a:doc_mc, 'deprecated')
    echohl Error
    echo 'Deprecated in '.get(a:doc_mc, 'deprecated', 'Oops, deprecated broke')
  endif

  " TODO: Looks odd when there's no docstring
  if !or(has_key(a:doc_mc, 'added'), has_key(a:doc_mc, 'deprecated'))
    echo "\n"
  endif

  echohl Normal
  if has_key(a:doc_mc, 'doc')
    echo substitute(a:doc_mc['doc'], "^", "  ", "g")
  endif

  if has_key(a:doc_mc, 'url')
    echo "Please see ".a:doc_mc['url']
  endif

  if has_key(a:doc_mc, 'javadoc')
    echo "For additional documentation, see the Javadoc: ".a:doc_mc['javadoc']
  endif

  if has_key(a:doc_mc, 'spec')
    echo "\nSpec: "
    for s in a:doc_mc['spec']
      echo "  ".s
    endfor
  endif

  if has_key(a:doc_mc, 'see-also')
    echo "\nAlso see: "
    for sa in a:doc_mc['see-also']
      echo "  ".sa
    endfor
  endif
endf

fun! replant#buffer_doc(doc_mc)
  call luaeval('require("replant").buffer_doc(_A)', a:doc_mc)
endf

fun! replant#url_to_vim(url)
  return luaeval('require("replant")["info-file->vim-file"](_A)', a:url)
endf

fun! replant#handle_plain_stack(error)
  let qfs = []
  call reverse(a:error)
  for e in a:error
    if has_key(e, 'stacktrace')
      call replant#handle#stacktrace_qf(qfs, e.stacktrace)
    endif
  endfor

  call replant#handle#insert_top_level_messages(qfs, a:error)

  call setloclist(0, qfs)
  lopen
endf

fun! replant#hl_state_to_group(state)
  let name = ''

  if get(a:state, 'fg') isnot 0
    let name .= 'fg'.get(a:state, 'fg')
  endif

  if get(a:state, 'bg') isnot 0
    let name .= 'bg'.get(a:state, 'bg')
  endif

  if get(a:state, 'attrs', {}) != {}
    let name .= 'attrs'.join(sort(keys(get(a:state, 'attrs'))), '')
  endif

  if name == ''
    return 'None'
  else
    let name = 'REPLANT_ANSI_HL_'.name
  endif

  let cmd = 'hi '.name

  if get(a:state, 'fg') isnot 0
    let fg = get(a:state, 'fg')
    let cmd .= ' ctermfg='.fg.' guifg='.fg
  endif

  if get(a:state, 'bg') isnot 0
    let bg = get(a:state, 'bg')
    let cmd .= ' ctermbg='.bg.' guibg='.bg
  endif

  if get(a:state, 'attrs', {}) != {}
    let attrs = join(sort(keys(get(a:state, 'attrs'))), ',')
    let cmd .= ' cterm='.attrs.' gui='.attrs
  endif

  execute cmd

  return name
endf

fun! replant#hl_state_update(state, escape)
  let x = a:escape

  if !has_key(a:state, 'attrs')
    let a:state['attrs'] = {}
  endif

  if x == '[m' || x == '[0m'
    " Reset everything
    let a:state['fg'] = 0
    let a:state['bg'] = 0
    let a:state['attrs'] = {}
    return a:state
  else
    let tokens = split(matchstr(x, '\e[\zs\(\d\+;\?\)\+\zem'), ';')

    for token in tokens
      " Attrs
      if token == 0
        let a:state['fg'] = 0
        let a:state['bg'] = 0
        let a:state['attrs'] = {}
      elseif token == 1
        let a:state['attrs']['bold'] = 1
      " vim doesn't support faint/dim
      " elseif token == 2
      "   let a:state['attrs']['Dim'] = 1
      elseif token == 3
        let a:state['attrs']['italic'] = 1
      elseif token == 4
        let a:state['attrs']['underline'] = 1
      elseif token == 7
        let a:state['attrs']['reverse'] = 1
      " FG
      elseif token == 30
        let a:state['fg'] = 'black'
      elseif token == 31
        let a:state['fg'] = 'red'
      elseif token == 32
        let a:state['fg'] = 'green'
      elseif token == 33
        let a:state['fg'] = 'yellow'
      elseif token == 34
        let a:state['fg'] = 'blue'
      elseif token == 35
        let a:state['fg'] = 'magenta'
      elseif token == 36
        let a:state['fg'] = 'cyan'
      elseif token == 37
        let a:state['fg'] = 'white'

        " BG
      elseif token == 40
        let a:state['bg'] = 'black'
      elseif token == 41
        let a:state['bg'] = 'red'
      elseif token == 42
        let a:state['bg'] = 'green'
      elseif token == 43
        let a:state['bg'] = 'yellow'
      elseif token == 44
        let a:state['bg'] = 'blue'
      elseif token == 45
        let a:state['bg'] = 'magenta'
      elseif token == 46
        let a:state['bg'] = 'cyan'
      elseif token == 47
        let a:state['bg'] = 'white'
      endif
    endfor

    return a:state
endf

fun! replant#echohl_ansi(string, state)
  let escape_re = '\(\(\e\[\(\d\+;\?\)\+m\)\|\e\[m\)'
  let magic_str = 'REPLANT_DELIM'

  for x in split(substitute(a:string, escape_re, magic_str.'\0'.magic_str, 'g'), magic_str)
    if x =~# escape_re
      let state = replant#hl_state_update(a:state, x)
      let group = replant#hl_state_to_group(a:state)

      execute 'echohl '.group
    else
      echon x
    endif
  endfor

  echohl None

  return a:state
endf

let s:handle_refresh_state = {}
let s:handle_refresh_last_is_out = {}

fun! replant#handle_refresh_msg(msg)
  if has_key(a:msg, 'status') && s:contains(a:msg['status'], 'invoking-before')
    echom '('.a:msg['before'].')'
  elseif has_key(a:msg, 'status') && s:contains(a:msg['status'], 'invoked-before')
    echom "…Done!"
  elseif has_key(a:msg, 'reloading')
    echom 'reloading: ('.join(a:msg['reloading'], " ").")"
  elseif has_key(a:msg, 'status') && s:contains(a:msg['status'], 'invoking-after')
    echom '('.a:msg['after'].')'
  elseif has_key(a:msg, 'status') && s:contains(a:msg['status'], 'invoked-after')
    echom '… Done!'
  elseif has_key(a:msg, 'out')
    if !get(s:handle_refresh_last_is_out, a:msg.id)
      echon "\n"
    endif

    let s:handle_refresh_state[a:msg.id] = replant#echohl_ansi(a:msg.out, get(s:handle_refresh_state, a:msg.id, {}))
  endif

  let s:handle_refresh_last_is_out[a:msg.id] = has_key(a:msg, 'out')

  if has_key(a:msg, 'status') && s:contains(a:msg['status'], 'error')
    call replant#handle_plain_stack(a:msg['error'])
  endif
endf

fun! replant#read_clj_file(filename)
  return join(readfile(globpath(&runtimepath, 'autoload/replant/'.a:filename)), "\n")
endf

fun! replant#detect_refresh_before()
  if exists('g:replant_refresh_before_hook')
    return g:replant_refresh_before_hook
  else
    let detected_before = fireplace#platform().eval(replant#read_clj_file('locate_before.clj'), {'ns': 'user'})['value']
    if detected_before !=# 'nil'
      return detected_before
    endif
  endif
endf

fun! replant#detect_refresh_after()
  if exists('g:replant_refresh_after_hook')
    return g:replant_refresh_after_hook
  else
    let detected_after = fireplace#platform().eval(replant#read_clj_file('locate_after.clj'), {'ns': 'user'})['value']
    if detected_after !=# 'nil'
      return detected_after
    endif
  endif
endf

function! replant#insert_ns_definition_maybe()
  try
    if &buftype !~# '^no' && &modifiable
      call append(0, '(ns '.replant#ui#expected_ns().')')
    endif
  catch /Fireplace:.*/
  endtry
endfunction
