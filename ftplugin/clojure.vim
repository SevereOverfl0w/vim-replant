" Use :call so that all echos are collected together
nnoremap <silent><buffer> <localleader>rf :<C-U>call replant#ui#refresh()<CR>
nnoremap <silent><buffer> <localleader>ra :<C-U>call replant#ui#refresh_all()<CR>

command! -buffer -nargs=? ReplantDoc call replant#doc(replant#message#send_collect(replant#doc_msg(fireplace#ns(), <f-args>)))

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
" noremap <buffer> K :call <SID>replant_doc()<CR>


function! SetupReplantBufferDoc()
  nunmap <buffer> K
  command! -buffer -nargs=? ReplantBufferDoc call replant#buffer_doc(replant#message#send_collect(replant#doc_msg(fireplace#ns(), <f-args>)))
  setlocal keywordprg=:ReplantBufferDoc
endfunction

command! -buffer -nargs=0 ReplantFindSymbol call replant#ui#find_symbol_under_cursor_quickfix()

command! -buffer -nargs=* -range=0 ReplantHotloadDependency call replant#ui#hotload_command(<line1>, <line2>, <f-args>)
command! -buffer -nargs=0 ReplantListResources call replant#ui#quickfix_resources_list()

command! -buffer -nargs=0 ReplantLastStacktrace call replant#ui#last_stacktrace()

command! -buffer -nargs=* ReplantTestProject call replant#ui#test_project(<f-args>)
command! -buffer -nargs=* ReplantRetestProject call replant#ui#retest_project(<f-args>)
nnoremap <silent><buffer> <localleader>rtp :<C-U>call replant#ui#test_project()<CR>
command! -buffer -nargs=+ ReplantTestStacktrace call replant#ui#test_stacktrace(<f-args>)
