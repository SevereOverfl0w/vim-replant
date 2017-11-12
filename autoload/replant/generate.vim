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
