function! replant#fzf#symbol_and_doc_to_map(idx, symbol_and_doc)
  let matches = matchlist(symbol_and_doc, '(S+): (.*)')
  let symbol = matches[1]
  let doc = matches[2]

  return {"symbol": symbol, "doc": doc}
endf

function! replant#fzf#symbol_jump(Action_resolve, argz)
  echom string(a:argz)
  let action_string = a:argz[0]
  let symbols_and_docs = a:argz[1:]

  if get(g:, 'replant_apropos_doc')
    let symbols = map(symbols_and_docs, function('replant#fzf#symbol_and_doc_to_map'))
  else
    let symbols = map(symbols_and_docs, {idx, x -> {"symbol": x}})
  endif

  let [action_type, action_data] = a:Action_resolve(action_string)
  if action_type ==# 'jump'
    call replant#ui#jump_to_source_full_symbol(action_data, symbols[0].symbol)
  elseif action_type ==# 'doc'
    call replant#buffer_doc(replant#message#send_collect(replant#doc_msg('clojure.core', symbols[0].symbol)))
  elseif action_type ==# 'test'
    call replant#ui#test_vars(map(symbols, {idx, x -> x.symbol}))
  endif
endf
