fun! replant#util#contains(list, v)
  for item in a:list
    if a:v == item
      return 1
    endif
  endfor

  return 0
endf
