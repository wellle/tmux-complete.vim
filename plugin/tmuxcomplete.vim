if exists("g:tmuxcomplete#loaded") || &cp || v:version < 700
    finish
endif
let g:tmuxcomplete#loaded = '0.1.3' " version number

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

    let s:options = get(g:, 'tmuxcomplete#asyncomplete_source_options', {})
    autocmd User asyncomplete_setup call asyncomplete#sources#tmuxcomplete#register(s:options)

    autocmd User Ncm2Plugin call ncm2#sources#tmuxcomplete#register()

    if exists('g:loaded_compe')
      lua require'compe'.register_source('tmux', require'compe_tmux')
    endif
endfunction

call s:init()
