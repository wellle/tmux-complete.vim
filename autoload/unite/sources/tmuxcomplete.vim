let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#tmuxcomplete#define()
  return s:s
endfunction

" define the tmuxcomplete source
let s:s = {
      \ 'name' : 'tmuxcomplete',
      \ 'description' : 'strings from tmux sessions',
      \ 'hooks' : {},
      \ 'max_candidates' : 0,
      \ 'default_kind' : 'word',
      \ 'sorters' : 'sorter_rank',
      \ 'default_action' : 'insert',
      \ 'source__maxstrings' : 0,
      \ }

" function! s:s.hooks.on_init(args, context)
"   call unite#print_source_message('tmux content', s:s.name)
" endfunction

" provides the results for unite to search/filter/sort.
function! s:s.gather_candidates(args, context)
  return map(tmuxcomplete#words(s:s.source__maxstrings), "{
        \ 'word' : v:val,
        \ 'is_multiline' : 0,
        \ 'action__text' : v:val,
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
