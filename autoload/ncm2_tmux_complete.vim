if get(s:, 'loaded', 0)
    finish
endif
let s:loaded = 1

let g:ncm2_tmux_complete_enabled = get(g:, 'ncm2_tmux_complete_enabled',  1)

let g:ncm2_tmux_complete#proc = yarp#py3('ncm2_tmux_complete')

let g:ncm2_tmux_complete#source = get(g:, 'ncm2_tmux_complete#source', {
            \ 'name': 'tmux',
            \ 'priority': 4,
            \ 'mark': 'tmux',
            \ 'on_complete': 'ncm2_tmux_complete#on_complete',
            \ 'on_warmup': 'ncm2_tmux_complete#on_warmup'
            \ })

let g:ncm2_tmux_complete#source = extend(g:ncm2_tmux_complete#source,
            \ get(g:, 'ncm2_tmux_complete#source_override', {}),
            \ 'force')

function! ncm2_tmux_complete#init()
    call ncm2#register_source(g:ncm2_tmux_complete#source)
endfunction

function! ncm2_tmux_complete#on_warmup(ctx)
    call g:ncm2_tmux_complete#proc.jobstart()
endfunction

function! ncm2_tmux_complete#on_complete(ctx)
    let s:is_enabled = get(b:, 'ncm2_tmux_complete_enabled',
                \ get(g:, 'ncm2_tmux_complete_enabled', 1))
    if ! s:is_enabled
        return
    endif
    call g:ncm2_tmux_complete#proc.try_notify('on_complete', a:ctx)
endfunction
