fun! s:get_port()
  let l:platform = fireplace#platform()

  if has_key(l:platform, 'transport') && has_key(l:platform['transport'], 'url')
    let l:url = l:platform['transport']['url']
    let l:port = matchstr(l:url, ':\zs\d\+$')
    return l:port
  else
    return l:platform['connection']['transport']['port']
  endif
endf

fun! replant#send#message(msg)
  let l:port = s:get_port()
  return G_replant_send_message(l:port, a:msg)
endf

fun! replant#send#message_callback(msg, callback)
  let l:port = s:get_port()
  return G_replant_send_message_callback(l:port, a:msg, a:callback)
endf

fun! replant#send#message_callback_async(msg, callback)
  let l:port = s:get_port()
  return G_replant_send_message_callback_async(l:port, a:msg, a:callback)
endf

fun! replant#send#message_callback_forever(msg, callback)
  let l:port = s:get_port()
  return G_replant_send_message_callback_forever(l:port, a:msg, a:callback)
endf
