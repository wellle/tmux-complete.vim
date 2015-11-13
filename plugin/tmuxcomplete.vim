if exists("g:tmuxcomplete#loaded") || &cp || v:version < 700
    finish
endif
let g:tmuxcomplete#loaded = '0.1.1' " version number

function! s:init()
    let trigger = get(g:, 'tmuxcomplete#trigger', 'completefunc')

    if trigger ==# ''
        " no trigger
    elseif trigger ==# 'completefunc'
        set completefunc=tmuxcomplete#complete
    elseif trigger ==# 'omnifunc'
        set omnifunc=tmuxcomplete#complete
    else
        echoerr "tmux-complete: unknown trigger: '" . trigger . "'"
    endif
endfunction

call s:init()
