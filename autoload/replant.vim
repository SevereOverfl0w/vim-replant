fun! replant#send_message(msg)
  let l:port = fireplace#client()['connection']['transport']['port']
  return G_replant_send_message(l:port, a:msg)
endf

fun! replant#collect_message(ms)
  let r = {}

  for m in a:ms
    for [k, v] in items(m)
      if !has_key(r, k)
        let r[k] = v
      else
        if k == "out"
          let r[k] .= v
        endif
      endif
    endfor
  endfor

  return r
endf

fun! replant#send_collect_message(msg)
  let ms = replant#send_message(a:msg)
  return replant#collect_message(ms)
endf

fun s:nrepl_dict_get(m, k)
  if has_key(a:m, a:k)
    return a:m[a:k]
  endif
endf

fun! replant#user_eval(code)
  let mc = replant#send_collect_message({'op': 'eval', 'code': a:code})
  if has_key(mc, "out")
    echo mc["out"]
    echo "---"
  endif
  echo mc["value"]

  return mc
endf

fun! replant#doc_msg(ns, symbol)
  return {'op': 'info', 'symbol': a:symbol, 'ns': a:ns}
endf

fun! s:contains(ls, v)
  for item in a:ls
    if a:v == item
      return 1
    endif
  endfor

  return 0
endf

fun! replant#doc(doc_mc)
  if s:contains(a:doc_mc['status'], 'no-info')
    echohl Error
    echo "No doc found"
    echohl Normal
    return
  endif
  if get(a:doc_mc, 'macro') is 'true'
    echohl Macro
  elseif get(a:doc_mc, 'special-form') is 'true'
    echohl Special
  elseif has_key(a:doc_mc, 'arglists-str')
    echohl Function
  elseif has_key(a:doc_mc, 'class')
    echohl StorageClass
  elseif has_key(a:doc_mc, 'ns') && !has_key(a:doc_mc, 'name')
    " A namespace
    echohl Macro
  else
    echohl Error
  endif

  let clj_name = ""
  if has_key(a:doc_mc, 'ns')
    if !has_key(a:doc_mc, 'name')
      echo get(a:doc_mc, 'ns')
    else
      let clj_name = get(a:doc_mc, 'ns').'/'.get(a:doc_mc, 'name')
    endif
  else
    let clj_name = get(a:doc_mc, 'name')
  endif

  let java_name = ""
  if has_key(a:doc_mc, 'member')
    let java_name = get(a:doc_mc, 'class').'/'.a:doc_mc['member']
  else
    let java_name = get(a:doc_mc, 'class')
  endif

  if has_key(a:doc_mc, 'class')
    echo java_name
  else
    echo clj_name
  endif

  echohl Normal

  if has_key(a:doc_mc, 'super')
    echo '    Extends: '.a:doc_mc['super']
  endif

  if has_key(a:doc_mc, 'interfaces')
    let l:line_prefix = '    Implements: '
    let l:subline_prefix = repeat(' ', strlen(l:line_prefix))
    echo l:line_prefix.a:doc_mc['interfaces'][0]
    echo l:subline_prefix.join(a:doc_mc['interfaces'][1:], "\n".l:subline_prefix)
  endif

  let l:forms = split(get(a:doc_mc, 'forms-str', get(a:doc_mc, 'arglists-str', '')), "\n")

  for f in l:forms
    echo " ".f
  endfor

  echohl Normal
  let var_type = [['macro', 'Macro'], ['special', 'Special Form']]
  for [k, v] in var_type
    if get(a:doc_mc, k) == v:true
      echo v
    endif
  endfor

  if has_key(a:doc_mc, 'added')
    echohl Comment
    echo 'Added in '. get(a:doc_mc, 'added', 'Oops, added broke')
  endif

  if has_key(a:doc_mc, 'deprecated')
    echohl Error
    echo 'Deprecated in '.get(a:doc_mc, 'deprecated', 'Oops, deprecated broke')
  endif

  " TODO: Looks odd when there's no docstring
  if !or(has_key(a:doc_mc, 'added'), has_key(a:doc_mc, 'deprecated'))
    echo "\n"
  endif

  echohl Normal
  if has_key(a:doc_mc, 'doc')
    echo substitute(a:doc_mc['doc'], "^", "  ", "g")
  endif

  if has_key(a:doc_mc, 'url')
    echo "Please see ".a:doc_mc['url']
  endif

  if has_key(a:doc_mc, 'javadoc')
    echo "For additional documentation, see the Javadoc: ".a:doc_mc['javadoc']
  endif

  if has_key(a:doc_mc, 'spec')
    echo "\nSpec: "
    for s in a:doc_mc['spec']
      echo "  ".s
    endfor
  endif

  if has_key(a:doc_mc, 'see-also')
    echo "\nAlso see: "
    for sa in a:doc_mc['see-also']
      echo "  ".sa
    endfor
  endif
endf

fun! replant#buffer_doc(doc_mc)
  call luaeval('require("replant").buffer_doc(_A)', a:doc_mc)
endf

fun! replant#handle_plain_stack(error)
  for e in a:error
    if has_key(e, 'file')
      echohl Error
      echo e['file'].':'.e['line'].':'.e['column'].': '.e['message']
      echohl Normal
    endif
  endfor
endf

fun! replant#refresh(refresh_msgs)
  for msg in a:refresh_msgs
    if has_key(msg, 'status') && s:contains(msg['status'], 'invoked-before')
      echo '('.msg['before'].')'
    endif

    if has_key(msg, 'reloading')
      echo 'reloading: ('.join(msg['reloading'], " ").')'
    endif

    if has_key(msg, 'status') && s:contains(msg['status'], 'error')
      call replant#handle_plain_stack(refresh_mc['error'])
    endif

    if has_key(msg, 'status') && s:contains(msg['status'], 'invoked-after')
      echo '('.msg['after'].')'
    endif
  endfor
endf

fun! replant#read_clj_file(filename)
  return join(readfile(globpath(&runtimepath, 'autoload/replant/'.a:filename)), "\n")
endf

fun! replant#detect_refresh_before()
  if exists('g:replant_refresh_before_hook')
    return g:replant_refresh_before_hook
  else
    let detected_before = fireplace#client().eval(replant#read_clj_file('locate_before.clj'), {'ns': 'user'})['value']
    if detected_before !=# 'nil'
      return detected_before
    endif
  endif
endf

fun! replant#detect_refresh_after()
  if exists('g:replant_refresh_after_hook')
    return g:replant_refresh_after_hook
  else
    let detected_after = fireplace#client().eval(replant#read_clj_file('locate_after.clj'), {'ns': 'user'})['value']
    if detected_after !=# 'nil'
      return detected_after
    endif
  endif
endf
