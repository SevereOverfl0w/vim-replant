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
