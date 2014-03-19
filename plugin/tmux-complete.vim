function! CompleteScript(findstart, base)
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

    let base_pattern = '^' . escape(a:base, '*^$][.\') . '.'
    let list_args    = get(g:, 'tmux_complete_list_args', '-a')
    let capture_args = get(g:, 'tmux_complete_capture_args', '-J')

    let command  = 'sh ' . s:script
    let command .= ' ' . shellescape(base_pattern)
    let command .= ' ' . shellescape(list_args)
    let command .= ' ' . shellescape(capture_args)

    let words = system(command)
    for word in split(words)
        call complete_add(word)
    endfor
    return []
endfun

let s:script = shellescape(expand('<sfile>:h:h') . "/sh/tmuxwords.sh")
set completefunc=CompleteScript
