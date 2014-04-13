if exists("g:tmuxcomplete#loaded") || &cp || v:version < 700
    finish
endif
let g:tmuxcomplete#loaded = '0.0.1' " version number

set completefunc=tmuxcomplete#complete
