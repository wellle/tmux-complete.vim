function! tmuxcomplete#words(scrollback)
    let capture_args = '-J -S -' . a:scrollback
    return tmuxcomplete#completions('', capture_args)
endfunction

let s:script = expand('<sfile>:h:h') . "/sh/tmuxwords.sh"

function! tmuxcomplete#completions(base, capture_args)
    let base_pattern = '^' . escape(a:base, '*^$][.\') . '.'
    let list_args    = get(g:, 'tmux_complete_list_args', '-a')

    let command  = 'sh ' . shellescape(s:script)
    let command .=   ' ' . shellescape(base_pattern)
    let command .=   ' ' . shellescape(list_args)
    let command .=   ' ' . shellescape(a:capture_args)

    let completions = system(command)
    if v:shell_error == 0
        return split(completions)
    else
        return []
    endif
endfunction

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

