function! CompleteScript(findstart, base)
    if a:findstart
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        while start > 0 && line[start - 1] =~ get(g:, 'tmux_complete_match', '\a')
            let start -= 1
        endwhile
        return start
    endif

    " find months matching with "a:base"
    let command = 'sh ' . shellescape(expand(s:script)) . ' ' . shellescape('^' . escape(a:base, '*^$][.\') . '.')
    let words = system(command)
    for word in split(words)
        call complete_add(word)
    endfor
    return []
endfun

let s:script = expand('<sfile>:h:h') . "/sh/tmuxwords.sh"
set completefunc=CompleteScript
