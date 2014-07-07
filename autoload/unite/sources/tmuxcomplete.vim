let s:save_cpo = &cpo
set cpo&vim

function! unite#sources#tmuxcomplete#define()
  return [ s:words, s:lines ]
endfunction

" tmuxcomplete WORDS source
let s:words = {
      \ 'name' : 'tmuxcomplete',
      \ 'description' : 'words in the current tmux session',
      \ 'hooks' : {},
      \ 'max_candidates' : 0,
      \ 'default_kind' : 'word',
      \ 'sorters' : 'sorter_rank',
      \ 'default_action' : 'insert',
      \ 'source__maxstrings' : 0,
      \ }

" function! s:words.hooks.on_init(args, context)
"   call unite#print_source_message('tmux content', s:words.name)
" endfunction

" provides the results for unite to search/filter/sort.
function! s:words.gather_candidates(args, context)
  return map(tmuxcomplete#list('words', 0), "{
        \ 'word' : v:val,
        \ 'is_multiline' : 0,
        \ 'action__text' : v:val,
        \ }")
endfunction

" tmuxcomplete LINES source
let s:lines = deepcopy(s:words)
let s:lines.name = 'tmuxcomplete/lines'
let s:lines.description = 'lines in the current tmux session'

function! s:lines.gather_candidates(args, context)
  return map(tmuxcomplete#list('lines', 0), "{
        \ 'word' : v:val,
        \ 'is_multiline' : 0,
        \ 'action__text' : v:val,
        \ }")
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
