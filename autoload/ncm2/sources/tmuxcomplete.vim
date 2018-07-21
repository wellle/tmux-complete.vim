if get(s:, 'loaded', 0)
    finish
endif
let s:loaded = 1

let g:ncm2_tmux_complete_enabled = get(g:, 'ncm2_tmux_complete_enabled',  1)

let g:ncm2_tmux_complete#proc = yarp#py3('ncm2_tmux_complete')

let g:ncm2_tmux_complete#source = get(g:, 'ncm2_tmux_complete#source', {
            \ 'name': 'tmux-complete',
            \ 'mark': 'tmux',
            \ 'priority': 4,
            \ 'on_complete': 'ncm2#sources#tmuxcomplete#on_complete',
            \ 'on_warmup':   'ncm2#sources#tmuxcomplete#on_warmup'
            \ })

let g:ncm2_tmux_complete#source = extend(g:ncm2_tmux_complete#source,
            \ get(g:, 'ncm2_tmux_complete#source_override', {}),
            \ 'force')

function! ncm2#sources#tmuxcomplete#register()
    call ncm2#register_source(g:ncm2_tmux_complete#source)
endfunction

function! ncm2#sources#tmuxcomplete#on_warmup(ctx)
    call g:ncm2_tmux_complete#proc.jobstart()
endfunction

function! ncm2#sources#tmuxcomplete#on_complete(ctx)
    let s:is_enabled = get(b:, 'ncm2_tmux_complete_enabled',
                \ get(g:, 'ncm2_tmux_complete_enabled', 1))
    if ! s:is_enabled
        return
    endif
    call g:ncm2_tmux_complete#proc.try_notify('on_complete', a:ctx)
endfunction
