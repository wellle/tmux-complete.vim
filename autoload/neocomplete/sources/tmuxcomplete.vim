let s:save_cpo = &cpo
set cpo&vim

let s:source = {
            \ 'name' : 'tmux-complete',
            \ 'kind' : 'keyword',
            \ 'mark' : '[tmux]',
            \ 'rank' : 4,
            \ }

function! s:source.gather_candidates(context)
    return tmuxcomplete#gather_candidates()
endfunction

function! neocomplete#sources#tmuxcomplete#define()
    return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
