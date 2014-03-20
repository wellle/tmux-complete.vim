if exists("g:loaded_tmux_complete") || &cp || v:version < 700
    finish
endif
let g:loaded_tmux_complete = '0.0.1' " version number
let s:save_cpoptions = &cpoptions
set cpo&vim

function! tmuxcomplete#complete(findstart, base)
    if a:findstart
        let match = get(g:, 'tmux_complete_match', '\a')
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ match
            let start -= 1
        endwhile
        return start
    endif

    " find words matching with "a:base"
    let capture_args = get(g:, 'tmux_complete_capture_args', '-J')
    return tmuxcomplete#completions(a:base, capture_args)
endfun

function! CompleteScript(findstart, base)
    return tmuxcomplete#complete(a:findstart, a:base)
endfun

set completefunc=CompleteScript

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
