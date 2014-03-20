if exists("g:loaded_tmux_complete") || &cp || v:version < 700
    finish
endif
let g:loaded_tmux_complete = '0.0.1' " version number

set completefunc=tmuxcomplete#complete
