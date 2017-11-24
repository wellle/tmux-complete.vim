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
    let a:opt['kwlen'] = len(l:kw)
    if a:opt['kwlen'] < 1
        return
    endif

    let l:cmd = tmuxcomplete#getcommandlist(l:kw, 'words')
    let a:opt['buffer'] = ''

    let l:jobid = async#job#start(l:cmd, {
                \ 'on_stdout': function('s:handler', [a:opt, a:ctx]),
                \ 'on_exit':   function('s:handler', [a:opt, a:ctx]),
                \ })
endfunction

function! s:handler(opt, ctx, id, data, event) abort
    if a:event ==? 'stdout'
        let a:opt['buffer'] .= join(a:data)

    elseif a:event ==? 'exit'
        let l:startcol = a:ctx['col'] - a:opt['kwlen']
        let l:words = split(a:opt['buffer'])
        let l:matches = map(l:words,'{"word":v:val,"icase":1,"menu":"[' . a:opt['name'] . ']"}')

        call asyncomplete#complete(a:opt['name'], a:ctx, l:startcol, l:matches)
    endif
endfunction
