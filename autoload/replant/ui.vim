fun! replant#ui#refresh()
  call replant#send#message_callback(replant#generate#refresh(), 'replant#handle_refresh_msg')
endf

fun! replant#ui#refresh_all()
  call replant#send#message_callback(replant#generate#refresh_all(), 'replant#handle_refresh_msg')
endf

fun! replant#ui#find_symbol_under_cursor_quickfix()
  let msg = replant#generate#find_symbol_under_cursor()
  if msg isnot 0
    call replant#handle#quickfix_find_symbol(replant#send#message(msg))
    " TODO: Consider triggering an autocmd that vim-qf can respond to here, in
    " order to be less opinionated
    cwindow
  endif
endf

fun! replant#ui#hotload_separately(artifact, version)
  let msg = {'op': 'hotload-dependency', 'coordinates': '['.a:artifact.' "'.a:version.'"]'}
  call replant#handle#hotload(replant#message#send_collect(msg))
endf

fun! replant#ui#hotload_vector(vector)
  let msg = {'op': 'hotload-dependency', 'coordinates': a:vector}
  call replant#handle#hotload(replant#message#send_collect(msg))
endf

fun! replant#ui#hotload_command(linea, lineb, ...)
  if a:0 isnot 0 && a:0 isnot 2
    echoerr 'Invalid number of arguments'
    return
  endif

  if a:0 is 0
    call replant#ui#hotload_vector(join(getline(a:linea, a:lineb), "\n"))
  else
    call replant#ui#hotload_separately(a:1, a:2)
  endif
endf
