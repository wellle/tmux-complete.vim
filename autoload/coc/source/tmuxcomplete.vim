function! coc#source#tmuxcomplete#init() abort
  return {
        \ 'priority': 1,
        \ 'shortcut': 'TMUX',
        \}
endfunction

function! coc#source#tmuxcomplete#complete(opt, cb) abort
  let items = tmuxcomplete#gather_candidates()
  call a:cb(s:ListToDict(items))
endfunction

function! s:ListToDict(items)
  let res = []
  for item in a:items
    call add(res, {'word' : item})
  endfor
  return res
endfunction