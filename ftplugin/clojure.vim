nnoremap <buffer><expr> <localleader>rf replant#refresh(replant#send_collect_message({'op': 'refresh'}))
nnoremap <buffer><expr> <localleader>ra replant#refresh(replant#send_collect_message({'op': 'refresh-all'}))

command! -buffer -nargs=? ReplantDoc call replant#doc(replant#send_collect_message(replant#doc_msg(fireplace#ns(), <f-args>)))

fun! s:replant_doc(...)
  if a:0 == 0
    let symbol = expand('<cword>')
  else
    let symbol = a:1
  endif

  execute 'ReplantDoc '.l:symbol
endf

" Cannot use 'keywordprg' due to it only running the last echo. It might be
" better to do a split like `:help`
" I won't pretend to know why, but using <expr> here, also has the same bug as
" setting 'keywordprg'
noremap <buffer> K :call <SID>replant_doc()<CR>
