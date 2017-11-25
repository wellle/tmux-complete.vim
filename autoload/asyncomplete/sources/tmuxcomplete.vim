function! asyncomplete#sources#tmuxcomplete#register(opts)
    let l:opts = extend(extend({}, a:opts), {
                \ 'name':      'tmuxcomplete',
                \ 'whitelist': ['*'],
                \ 'completor': function('asyncomplete#sources#tmuxcomplete#completor'),
                \ })
    call asyncomplete#register_source(l:opts)
endfunction

function! asyncomplete#sources#tmuxcomplete#completor(opt, ctx)
    " taken from asyncomplete-buffer
    let l:kw = matchstr(a:ctx['typed'], '\w\+$')
    let l:kwlen = len(l:kw)
    if l:kwlen < 1
        return
    endif

    let l:params = {
                \ 'name':     a:opt['name'],
                \ 'ctx':      a:ctx,
                \ 'startcol': a:ctx['col'] - l:kwlen,
                \ 'buffer':   ''
                \ }

    let l:cmd = tmuxcomplete#getcommandlist(l:kw, 'words')
    let l:jobid = async#job#start(l:cmd, {
                \ 'on_stdout': function('s:handler', [l:params]),
                \ 'on_exit':   function('s:handler', [l:params]),
                \ })
endfunction

function! s:handler(params, id, data, event) abort
    if a:event ==? 'stdout'
        let a:params['buffer'] .= join(a:data)

    elseif a:event ==? 'exit'
        let l:words = split(a:params['buffer'])
        let l:matches = map(l:words, '{"word":v:val,"icase":1,"menu":"[' . a:params['name'] . ']"}')

        call asyncomplete#complete(a:params['name'], a:params['ctx'], a:params['startcol'], l:matches)
    endif
endfunction
