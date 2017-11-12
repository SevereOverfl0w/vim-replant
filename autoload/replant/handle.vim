fun! replant#handle#quickfix_find_symbol(msgs)
  let qfs = []
  for msg in a:msgs
    if has_key(msg, 'occurrence')
      let occurrence = msg['occurrence']
      let d = {}
      let d.filename = fnamemodify(occurrence.file, ':~:.')
      let d.lnum = occurrence['line-beg']
      let d.col = occurrence['col-beg']
      let d.text = occurrence['match']
      call add(qfs, d)
    elseif has_key(msg, 'error')
      echo msg['error']
      return 0
    endif
  endfor

  call setqflist(qfs)
endf
