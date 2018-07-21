let s:save_cpo = &cpo
set cpo&vim

let s:source = {
            \ 'name' : 'tmux-complete',
            \ 'kind' : 'keyword',
            \ 'mark' : '[tmux]',
            \ 'rank' : 4,
            \ 'min_pattern_length' : g:neocomplcache_auto_completion_start_length,
            \ }

function! s:source.gather_candidates(context)
    return tmuxcomplete#complete(0, a:context.complete_str)
endfunction

function! neocomplcache#sources#tmuxcomplete#define()
    return s:source
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
