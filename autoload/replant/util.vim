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

  if has_key(o, 'include-meta-key')
    let vq['include-meta-key'] = get(o, 'include-meta-key')
  endif

  if has_key(o, 'exclude-meta-key')
    let vq['exclude-meta-key'] = get(o, 'exclude-meta-key')
  endif

  return vq
endf

func! replant#util#replace_ns(lines)
  let x = winsaveview()
  let skip = 'synIDattr(synID(line("."),col("."),1),"name") =~? "comment\\|string\\|char\\|regexp"'

  call cursor(1, 1)

  let [start_lnum, start_col] = searchpos('(ns')

  if start_lnum == 0
    return
  endif

  let [end_lnum, end_col] = searchpairpos('(ns', '', ')', 'n', skip)

  echo start_lnum . ' ' . end_lnum

  call nvim_buf_set_lines(bufnr(''), start_lnum - 1, end_lnum, 0, a:lines)

  call winrestview(x)
endf
