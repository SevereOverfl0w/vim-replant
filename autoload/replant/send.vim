fun! replant#send#message(msg)
  return fireplace#message(a:msg, v:t_list)
endf

fun! replant#send#message_callback(msg, callback)
  let id = fireplace#message(a:msg, function(a:callback))
  return fireplace#wait(id)
endf

fun! replant#send#message_callback_async(msg, callback)
  return fireplace#message(a:msg, function(a:callback))
endf
