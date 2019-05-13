function! tmuxcomplete#init()
    let s:capture_args = get(g:, 'tmuxcomplete#capture_args', '?')
    if s:capture_args == '?'
        call system('tmux capture-pane -J &> /dev/null') " check for -J flag
        let s:capture_args = v:shell_error == 0 ? '-J' : ''
    endif
endfunction

function! tmuxcomplete#list(splitmode, scrollback)
    let capture_args = s:capture_args . ' -S -' . a:scrollback
    return tmuxcomplete#completions('', capture_args, a:splitmode)
endfunction

let s:script = expand('<sfile>:h:h') . "/sh/tmuxcomplete"

function! s:build_command(base, capture_args, splitmode, as)
    let pattern   = '^' . escape(a:base, '*^$][.\') . '.'
    let list_args = get(g:, 'tmuxcomplete#list_args', '-a')
    let grep_args = tmuxcomplete#grepargs(a:base)

    let command = s:newcommand(a:as)
    let command = s:addcommand2(command, a:as, 'sh', s:script)
    let command = s:addcommand2(command, a:as, '-p', pattern)
    let command = s:addcommand2(command, a:as, '-s', a:splitmode)
    let command = s:addcommand2(command, a:as, '-l', list_args)
    let command = s:addcommand2(command, a:as, '-c', a:capture_args)
    let command = s:addcommand2(command, a:as, '-g', grep_args)

    if $TMUX_PANE !=# "" " if running inside tmux
        let command = s:addcommand1(command, a:as, '-e') " exclude current pane
    endif

    return command
endfunction

function! tmuxcomplete#getcommand(base, splitmode)
    return s:build_command(a:base, s:capture_args, a:splitmode, 'string')
endfunction

function! tmuxcomplete#getcommandlist(base, scrollback, splitmode)
    let capture_args = s:capture_args . ' -S -' . a:scrollback
    return s:build_command(a:base, capture_args, a:splitmode, 'list')
endfunction

function! tmuxcomplete#completions(base, capture_args, splitmode)
    let command = s:build_command(a:base, a:capture_args, a:splitmode, 'string')

    let completions = system(command) " TODO: use systemlist()?
    if v:shell_error != 0
        return []
    endif

    return split(completions, '\n')
endfunction

function! tmuxcomplete#complete(findstart, base)
    if a:findstart
        let line = getline('.')
        let max = col('.') - 1
        if get(g:, 'tmuxcomplete#mode', 'word') == 'WORD'
            return tmuxcomplete#findstartWORD(line, max)
        else
            return tmuxcomplete#findstartword(line, max)
        endif
    endif
    " find words matching with "a:base"
    return tmuxcomplete#completions(a:base, s:capture_args, 'words')
endfun

function! tmuxcomplete#findstartword(line, max)
    let start = a:max
    " walk left upto first non word character
    while start > 0 && a:line[start - 1] =~ '\a'
        let start -= 1
    endwhile
    return start
endfunction

function! tmuxcomplete#findstartWORD(line, max)
    " locate the start of the word
    let start = a:max
    " walk left upto first non WORD character
    while start > 0 && a:line[start - 1] =~ '\S'
        let start -= 1
    endwhile
    " walk right onto first word character
    while start < a:max && a:line[start] =~ '\H'
        let start += 1
    endwhile
    return start
endfunction

function! tmuxcomplete#grepargs(base)
    if !&ignorecase
        return ''
    endif
    if !&smartcase
        return '-i'
    endif
    if a:base =~# '[A-Z]'
        return ''
    endif
    return '-i'
endfunction

function! s:newcommand(as)
    if a:as == 'list'
        return []
    else " string
        return ''
    endif
endfunction

function! s:addcommand1(command, as, value)
    if a:as == 'list'
        return add(a:command, a:value)
    else " string
        return (a:command == '' ? '' : a:command . ' ') . a:value
    endif
endfunction

function! s:addcommand2(command, as, key, value)
    if a:as == 'list'
        call   add(a:command, a:key)
        return add(a:command, a:value) " no escaping here
    else " string
        return (a:command == '' ? '' : a:command . ' ') . a:key . ' ' . shellescape(a:value)
    endif
endfunction

" for integration with completion frameworks
function! tmuxcomplete#gather_candidates()
    return tmuxcomplete#completions('', s:capture_args, 'words')
endfunction

call tmuxcomplete#init()
