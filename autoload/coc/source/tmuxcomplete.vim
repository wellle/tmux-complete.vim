function! coc#source#tmuxcomplete#init() abort
    return {
                \ 'priority': 1,
                \ 'shortcut': 'TMUX',
                \ }
endfunction

function! coc#source#tmuxcomplete#complete(opt, callback) abort
    let Callback = function('s:ListToDict', [a:callback]) " wrap callback
    call tmuxcomplete#async#gather_candidates(Callback)
endfunction

function! s:ListToDict(callback, items)
    let res = []
    for item in a:items
        call add(res, {'word' : item})
    endfor
    call a:callback(res)
endfunction
