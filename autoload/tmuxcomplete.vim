function! tmuxcomplete#completions(base, capture_args)
    let script       = expand('<sfile>:h:h') . "/sh/tmuxwords.sh"
    let base_pattern = '^' . escape(a:base, '*^$][.\') . '.'
    let list_args    = get(g:, 'tmux_complete_list_args', '-a')

    let command  = 'sh ' . shellescape(script)
    let command .=   ' ' . shellescape(base_pattern)
    let command .=   ' ' . shellescape(list_args)
    let command .=   ' ' . shellescape(a:capture_args)

    let completions = system(command)
    return split(completions)
endfunction
