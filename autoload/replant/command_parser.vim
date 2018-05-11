let s:V = vital#replant#new()
let s:A = s:V.import('ArgumentParser')

function! replant#command_parser#add_var_query(parser)
  call a:parser.add_argument(
        \ '--project', 'Only show project namespaces')

  call a:parser.add_argument(
        \ '--load-project',
        \ 'Load project namespaces when used with --project',
        \ {'deniable': 1, 'default': 1})

  call a:parser.add_argument(
        \ '--private', 'Include private vars in results')

  call a:parser.add_argument(
        \ '--test', 'Show only test vars in results')

  call a:parser.add_argument(
        \ '--include-meta-key',
        \ 'Include vars where this metadata is truthy',
        \ {'type': s:A.types.multiple})

  call a:parser.add_argument(
        \ '--exclude-meta-key',
        \ 'Include vars with this metadata',
        \ {'type': s:A.types.multiple})
endfunction

function! replant#command_parser#get_apropos() abort
  if exists('s:apropos_parser')
    return s:apropos_parser
  endif
  let s:apropos_parser = s:A.new({
        \ 'name': 'ReplantApropos',
        \ 'description': 'Search for vars',
        \})
  call replant#command_parser#add_var_query(s:apropos_parser)
  return s:apropos_parser
endfunction

function! replant#command_parser#parse_apropos(...) abort
  let parser = replant#command_parser#get_apropos()
  return call(parser.parse, a:000, parser)
endfunction

function! replant#command_parser#complete_apropos(...) abort
  let parser = replant#command_parser#get_apropos()
  return call(parser.complete, a:000, parser)
endfunction

function! replant#command_parser#get_test() abort
  if exists('s:test_parser')
    return s:test_parser
  endif
  let s:test_parser = s:A.new({
        \ 'name': 'ReplantTest',
        \ 'description': 'Test by query',
        \})
  call replant#command_parser#add_var_query(s:test_parser)
  return s:test_parser
endfunction

function! replant#command_parser#parse_test(...) abort
  let parser = replant#command_parser#get_test()
  return call(parser.parse, a:000, parser)
endfunction

function! replant#command_parser#complete_test(...) abort
  let parser = replant#command_parser#get_test()
  return call(parser.complete, a:000, parser)
endfunction
