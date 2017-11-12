fun! replant#message#collect(ms)
  let r = {}

  for m in a:ms
    for [k, v] in items(m)
      if !has_key(r, k)
        let r[k] = v
      else
        if k == "out"
          let r[k] .= v
        endif
      endif
    endfor
  endfor

  return r
endf

fun! replant#message#send_collect(msg)
  let ms = replant#send#message(a:msg)
  return replant#message#collect(ms)
endf

