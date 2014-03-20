if exists("g:loaded_tmux_complete") || &cp || v:version < 700
    finish
endif
let g:loaded_tmux_complete = '0.0.1' " version number
let s:save_cpoptions = &cpoptions
set cpo&vim

" Deprecated completion function
" use tmuxcomplete#complete
function! CompleteScript(findstart, base)
    return tmuxcomplete#complete(a:findstart, a:base)
endfun

set completefunc=tmuxcomplete#complete

let &cpoptions = s:save_cpoptions
unlet s:save_cpoptions
