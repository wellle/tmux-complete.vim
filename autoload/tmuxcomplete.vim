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

function! tmuxcomplete#completions(base, capture_args, splitmode)
    let pattern   = '^' . escape(a:base, '*^$][.\') . '.'
    let list_args = get(g:, 'tmuxcomplete#list_args', '-a')
    let grep_args = tmuxcomplete#grepargs(a:base)

    let command  =  'sh ' . shellescape(s:script)
    let command .= ' -p ' . shellescape(pattern)
    let command .= ' -s ' . shellescape(a:splitmode)
    let command .= ' -l ' . shellescape(list_args)
    let command .= ' -c ' . shellescape(a:capture_args)
    let command .= ' -g ' . shellescape(grep_args)

    if $TMUX_PANE !=# ""     " if running inside tmux
        let command .= ' -e' " exclude current pane
    endif

    let completions = system(command)
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

" for integration with completion frameworks
function! tmuxcomplete#gather_candidates()
    return tmuxcomplete#complete(0, '')
endfunction

call tmuxcomplete#init()
