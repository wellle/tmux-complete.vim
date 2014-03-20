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
    return split(completions)
endfunction
