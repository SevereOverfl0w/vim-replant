function! replant#fzf#symbol_jump(Action_resolve, argz)
  let [action_string, symbol_and_doc] = a:argz

  if get(g:, 'replant_apropos_doc')
    let matches = matchlist(symbol_and_doc, '\(\S\+\): \(.*\)')
    let symbol = matches[1]
    let doc = matches[2]
  else
    let symbol = symbol_and_doc
  endif

  let [action_type, action_data] = a:Action_resolve(action_string)
  if action_type ==# 'jump'
    call replant#ui#jump_to_source_full_symbol(action_data, symbol)
  elseif action_type ==# 'doc'
    call replant#buffer_doc(replant#message#send_collect(replant#doc_msg('clojure.core', symbol)))
  endif
endf
