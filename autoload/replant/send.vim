fun! replant#send#message(msg)
  let l:port = fireplace#client()['connection']['transport']['port']
  return G_replant_send_message(l:port, a:msg)
endf

fun! replant#send#message_callback(msg, callback)
  let l:port = fireplace#client()['connection']['transport']['port']
  return G_replant_send_message_callback(l:port, a:msg, a:callback)
endf


