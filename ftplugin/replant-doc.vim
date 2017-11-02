" This ensures that special keywords (**replantWORD**) are hidden entirely
setlocal conceallevel=3
" Hide concealed things despite moving cursor
setlocal concealcursor=nci

" Set fireplace ns, for evaluations
let b:fireplace_ns='user'

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
noremap <expr><buffer> K replant#doc(replant#send_collect_message(replant#doc_msg(fireplace#ns(), expand('<cword>'))))
