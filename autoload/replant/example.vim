function! replant#example#do(ns, name, source_bufnr) abort
  let res = G_replant_http_json(printf('https://conj.io/api/v2/org.clojure/clojure/1.9.0/clj/%s/%s?op=examples', a:ns, a:name))
  let f = printf('/replant/example/%s/%s', a:ns, a:name)
  let client = fireplace#client(a:source_bufnr)

  if len(res.body) < 1
    echo printf('No examples found for %s/%s', a:ns, a:name)
    return
  endif

  execute printf('topleft vsplit %s', f)
  setlocal buftype=nofile noswapfile ft=clojure
  let b:fireplace_ns = 'user'

  for example in res.body
    call append(line('$'), split(example, '\n'))
  endfor

  execute printf('Connect nrepl://%s:%s /replant/example/', client.connection.transport.host, client.connection.transport.port)
endfunction

function! replant#example#sym(...)
  let source = bufnr('')
  let sym = a:0 > 0 && a:1 != '' ? a:1 : expand('<cword>')

  let info = fireplace#info(sym)

  call replant#example#do(info.ns, info.name, source)
endf
