if !exists('g:tmux_complete_location') || g:tmux_complete_location == ''
    let g:tmux_complete_location =
        \ "$HOME/.vim/bundle/tmux-complete.vim"
endif

function! CompleteScript(findstart, base)
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ '\a'
            let start -= 1
        endwhile
        return start
    endif

    " find months matching with "a:base"
    let command = 'sh ' . s:script . ' ' . a:base
    let words = system(command)
    for word in split(words)
        call complete_add(word)
    endfor
    return []
endfun

let s:script = g:tmux_complete_location . "/sh/tmuxwords"
if !filereadable(s:script)
    echoerr "tmux-complete script not found at" s:script
    finish
endif

set completefunc=CompleteScript
