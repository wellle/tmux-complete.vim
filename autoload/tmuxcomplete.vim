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
        " locate the start of the word
        let line = getline('.')
        let start = col('.') - 1
        " walk left upto first non WORD character
        while start > 0 && line[start - 1] =~ '\S'
            let start -= 1
        endwhile
        " walk right onto first word character
        while start < len(line) && line[start] =~ '\H'
            let start += 1
        endwhile
        if start == len(line)
            return -2 " no word character found
        endif
        return start
    endif
    " find words matching with "a:base"
    let capture_args = get(g:, 'tmux_complete_capture_args', '-J')
    return tmuxcomplete#completions(a:base, capture_args)
endfun

