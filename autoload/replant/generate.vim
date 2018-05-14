fun! replant#generate#refresh()
  let msg = {'op': 'refresh'}
  let maybe_before = replant#detect_refresh_before()
  if type(maybe_before) == v:t_string
    let msg.before = maybe_before
  endif
  let maybe_after = replant#detect_refresh_after()
  if type(maybe_after) == v:t_string
    let msg.after = maybe_after
  endif

  return msg
endf

fun! replant#generate#refresh_all()
  let msg = replant#generate#refresh()
  let msg.op = 'refresh-all'
  return msg
endf

fun! replant#generate#find_symbol_under_cursor()
  let symbol = expand('<cword>')
  " Calculate symbol ns
  let info = replant#message#send_collect({'op': 'info', 'symbol': symbol, 'ns': fireplace#ns()})

  if !has_key(info, 'ns')
    echo "Couldn't find namespace for '".symbol."', maybe the namespace hasn't been loaded?"
    return 0
  endif

  let msg = {'op': 'find-symbol',
           \ 'ns': info['ns'],
           \ 'name': expand('<cword>'),
           \ 'file': expand('%:p'),
           \ 'line': line('.'),
           \ 'column': col('.'),
           \ 'serialization-format': 'bencode',
           \ 'ignore-errors': 1}
  return msg
endf

fun! replant#generate#resource_list()
  return {'op': 'resources-list'}
endf

fun! replant#generate#last_stacktrace()
  let msg = {'op': 'stacktrace',
           \ 'session': get(get(fireplace#client(), 'connection', {}), 'session')}

  return msg
endf

fun! replant#generate#test_project(args)
  let opts = a:args

  if get(a:args, 'load?')
    let opts['load?'] = 1
  endif

  let msg = extend({'op': 'test-all'}, opts)

  return msg
endf

fun! replant#generate#retest_project()
  return {'op': 'retest'}
endf

fun! replant#generate#test_vars(vars)
  return {'op': 'test-var-query', 'var-query': {'exactly': a:vars}}
endf

fun! replant#generate#test_results_info(msgs)
  " TODO: Refactor the find_test_result_msg out
  let result_msg = replant#handle#find_test_results_msg(a:msgs)
  let results = get(result_msg, 'results', {})

  let msgs = []

  for [ns, vars] in items(results)
    for [var, assertions] in items(vars)
      " TODO: Filter to only where an assertion didn't pass
      call add(msgs, {'op': 'info', 'ns': 'clojure.core', 'symbol': ns.'/'.var})
    endfor
  endfor

  return msgs
endf

fun! replant#generate#test_stacktrace(ns,var,index)
  return {'op': 'test-stacktrace', 'ns': a:ns, 'var': a:var, 'index': a:index}
endf

fun! replant#generate#apropos_var_query(var_query)
  return {'op': 'apropos', 'ns': fireplace#ns(), 'var-query': a:var_query, 'full-doc?': 1}
endf

fun! replant#generate#jump_to_source_full_symbol(full_symbol)
  return {'op': 'info', 'ns': 'clojure.core', 'symbol': a:full_symbol}
endf
