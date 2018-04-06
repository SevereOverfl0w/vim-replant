fun! replant#ui#refresh()
  call replant#send#message_callback(replant#generate#refresh(), 'replant#handle_refresh_msg')
endf

fun! replant#ui#refresh_all()
  call replant#send#message_callback(replant#generate#refresh_all(), 'replant#handle_refresh_msg')
endf

fun! replant#ui#find_symbol_under_cursor_quickfix()
  let msg = replant#generate#find_symbol_under_cursor()
  if msg isnot 0
    call replant#handle#quickfix_find_symbol(replant#send#message(msg))
    " TODO: Consider triggering an autocmd that vim-qf can respond to here, in
    " order to be less opinionated
    cwindow
  endif
endf

fun! replant#ui#hotload_separately(artifact, version)
  let msg = {'op': 'hotload-dependency', 'coordinates': '['.a:artifact.' "'.a:version.'"]'}
  call replant#handle#hotload(replant#message#send_collect(msg))
endf

fun! replant#ui#hotload_vector(vector)
  let msg = {'op': 'hotload-dependency', 'coordinates': a:vector}
  call replant#handle#hotload(replant#message#send_collect(msg))
endf

fun! replant#ui#hotload_command(linea, lineb, ...)
  if a:0 isnot 0 && a:0 isnot 2
    echoerr 'Invalid number of arguments'
    return
  endif

  if a:0 is 0
    call replant#ui#hotload_vector(join(getline(a:linea, a:lineb), "\n"))
  else
    call replant#ui#hotload_separately(a:1, a:2)
  endif
endf

fun! replant#ui#relpath_to_namespace(path)
  return luaeval('require("replant_raw")["path_to_ns"](_A)', fnamemodify(a:path, ':r'))
endf

fun! replant#ui#expected_ns(...)
  let buffer = a:000 is 1 ? a:1 : nvim_get_current_buf()
  let classpath = get(replant#send#message({'op': 'classpath'})[0], 'classpath')

  if classpath isnot 0
    let abspath = fnamemodify(bufname(buffer), ':p')
    let relpath = luaeval('require("replant_raw")["find_relpath"](_A.classpath, _A.abspath)',
          \ {'abspath': abspath, 'classpath': classpath})
    return replant#ui#relpath_to_namespace(relpath)
  endif
endf

fun! replant#ui#quickfix_resources_list()
  let send = replant#generate#resource_list()
  let msgs = replant#send#message(send)
  let qfs = replant#handle#quickfix_resources_list(msgs)
  call setqflist(qfs)
  copen
endf

fun! replant#ui#last_stacktrace()
  let send = replant#generate#last_stacktrace()
  let msgs = replant#send#message(send)

  let qfs = []

  call reverse(msgs)
  for e in msgs
    if has_key(e, 'stacktrace')
      call replant#handle#stacktrace_qf(qfs, e.stacktrace)
    endif
  endfor

  call replant#handle#insert_top_level_messages(qfs, msgs)

  call setloclist(0, qfs)
  lopen
endf
