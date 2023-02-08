fun! replant#send#message(msg)
  return fireplace#client().transport.Message(a:msg, v:t_list)
endf

fun! replant#send#message_callback(msg, callback)
  let id = fireplace#client().transport.Message(a:msg, function(a:callback))
  return fireplace#wait(id)
endf

fun! replant#send#message_callback_async(msg, callback)
  return fireplace#client().transport.Message(a:msg, function(a:callback))
endf
