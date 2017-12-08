" Hide long zipfiles
" It would be nice to do this only for replant buffers, but I don't know how
" to detect that.

setlocal concealcursor=nvic
setlocal conceallevel=2

call matchadd('Conceal', 'zipfile:.*::', 99, -1, {'conceal': ''})
