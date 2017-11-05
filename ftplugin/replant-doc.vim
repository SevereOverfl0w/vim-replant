nnoremap <buffer> q :<C-U>quit!<CR>

function! s:open_replant_jump()
  if b:replant_jump_file isnot 0
    execute ':edit +call\ cursor('.b:replant_jump_line.','.b:replant_jump_column.') '.b:replant_jump_file
  else
    echo 'Location unknown'
  endif
endfunction

nnoremap <buffer> gF :<C-U>call <SID>open_replant_jump()<CR>
