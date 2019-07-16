let s:winid = 0

function! s:FloatPeek(lines, PostSetup) abort
    if s:winid
        call replant#peek#ClosePeek()
    endif

    let bufhandle = nvim_create_buf(0, 1)
    call nvim_buf_set_lines(bufhandle, 0, -1, v:true, a:lines)

    " float the peek
    " TODO: bind these against screen width so they don't overflow on long
    " lines.
    let height = min([&lines - 3, len(a:lines)])
    let width = min([max(map(a:lines, {_, val -> len(val)})), float2nr(&columns - (&columns / 5))])
    let col = float2nr((&columns - width) / 2)
    let config = {
                \ 'relative': 'cursor',
                \ 'row': 0,
                \ 'col': 0,
                \ 'width': width,
                \ 'height': height
                \ }

    let s:winid = nvim_open_win(bufhandle, 1, config)
    setlocal nomodifiable
    call a:PostSetup(bufhandle, s:winid)

    nnoremap <buffer> q :call replant#peek#ClosePeek()<CR>

    augroup ClosePeekOnExitAU
        au!
        au BufLeave,WinLeave <buffer> call replant#peek#ClosePeek()
    augroup END
endfunction

function! replant#peek#FloatContents(lines, PostSetup)
    call s:FloatPeek(a:lines, a:PostSetup)
endfunction

function! replant#peek#ClosePeek()
    silent! augroup! ClosePeekOnExitAU
    silent! call nvim_win_close(s:winid, 1)
    let s:winid = 0
    " mapclear <buffer>
endfunction

" function! replant#peek#PromotePeek()
"     let save_pos = getpos('.')
"     let file = expand('%')
"
"     :q
"     execute ':' . g:replant#peek_split_command
"
"     execute ':e ' . file
"     call setpos('.', save_pos)
" endfunction
