let s:V = vital#replant#new()
let s:A = s:V.import('ArgumentParser')

function! replant#command_parser#add_var_query(parser)
  call a:parser.add_argument(
        \ '--project', 'Only show project namespaces')
  " See https://github.com/lambdalisue/vital-ArgumentParser/issues/10
  " call a:parser.add_argument(
  "       \ '--load-project', {'description': 'Load project namespaces when used with --project',
  "                         \  'deniable': 1, 'default': 1})
  call a:parser.add_argument(
        \ '--load-project', {'deniable': 1, 'default': 1})
  call a:parser.add_argument(
        \ '--private', 'Include private vars in results')
  call a:parser.add_argument(
        \ '--test', 'Show only test vars in results')
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
