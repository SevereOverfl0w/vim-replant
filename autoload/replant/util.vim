fun! replant#util#contains(list, v)
  for item in a:list
    if a:v == item
      return 1
    endif
  endfor

  return 0
endf

fun! replant#util#options2varquery(options)
  let o = a:options
  let vq = {'ns-query': {}}

  if get(o, 'project')
    let vq['ns-query']['project?'] = 1
  endif

  if get(o, 'load-project')
    let vq['ns-query']['load-project-ns?'] = 1
  endif

  if get(o, 'private')
    let vq['private?'] = 1
  endif

  if get(o, 'test')
    let vq['test?'] = 1
  endif

  return vq
endf