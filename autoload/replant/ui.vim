fun! replant#ui#refresh()
  call replant#refresh(replant#send_message(replant#generate#refresh()))
endf

fun! replant#ui#refresh_all()
  call replant#refresh(replant#send_message(replant#generate#refresh_all()))
endf
