function! tmuxcomplete#init()
    let s:capture_args = get(g:, 'tmuxcomplete#capture_args', '?')
    if s:capture_args == '?'
        call system('tmux capture-pane -J &> /dev/null') " check for -J flag
        let s:capture_args = v:shell_error == 0 ? '-J' : ''
    endif
endfunction

function! tmuxcomplete#words(scrollback, lines)
    let capture_args = s:capture_args . ' -S -' . a:scrollback
    return tmuxcomplete#completions('', capture_args, a:lines)
endfunction

let s:script = expand('<sfile>:h:h') . "/sh/tmuxwords.sh"

function! tmuxcomplete#completions(base, capture_args, lines)
    let base_pattern = '^' . escape(a:base, '*^$][.\') . '.'
    let list_args    = get(g:, 'tmuxcomplete#list_args', '-a')

    let command  = 'sh ' . shellescape(s:script) . (a:lines ? ' -l' : '')
    let command .=   ' ' . shellescape(base_pattern)
    let command .=   ' ' . shellescape(list_args)
    let command .=   ' ' . shellescape(a:capture_args)
    echom command

    let completions = system(command)
    if v:shell_error != 0
        return []
    elseif a:lines
        return split(completions, '\n')
    else
        return split(completions)
    endif
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
    return tmuxcomplete#completions(a:base, s:capture_args)
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

call tmuxcomplete#init()
