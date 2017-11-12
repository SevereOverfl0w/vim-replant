fun! replant#ui#refresh()
  call replant#send_message_callback(replant#generate#refresh(), 'replant#handle_refresh_msg')
endf

fun! replant#ui#refresh_all()
  call replant#send_message_callback(replant#generate#refresh_all(), 'replant#handle_refresh_msg')
endf

fun! replant#ui#find_symbol_under_cursor_quickfix()
  let msg = replant#generate#find_symbol_under_cursor()
  if msg isnot 0
    call replant#handle#quickfix_find_symbol(replant#send_message(msg))
    " TODO: Consider triggering an autocmd that vim-qf can respond to here, in
    " order to be less opinionated
    cwindow
  endif
endf
