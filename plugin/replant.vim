" luochen1990/rainbow integration, and probably others.
if exists('g:rainbow_conf')
  if !exists('g:rainbow_conf.separately')
    let g:rainbow_conf.separately = {}
  endif
  let g:rainbow_conf.separately['replant-doc'] = 0
endif
