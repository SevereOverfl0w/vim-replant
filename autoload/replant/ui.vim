fun! replant#ui#refresh()
  call replant#send_message_callback(replant#generate#refresh(), 'replant#handle_refresh_msg')
endf

fun! replant#ui#refresh_all()
  call replant#send_message_callback(replant#generate#refresh_all(), 'replant#handle_refresh_msg')
endf
