let s:defaultopts = {
            \ 'name':      'tmuxcomplete',
            \ 'whitelist': ['*'],
            \ 'completor': function('asyncomplete#sources#tmuxcomplete#completor'),
            \ }

function! asyncomplete#sources#tmuxcomplete#register(opts)
    let l:opts = extend(copy(s:defaultopts), a:opts)
    call asyncomplete#register_source(l:opts)
endfunction

function! asyncomplete#sources#tmuxcomplete#completor(opt, ctx)
    " taken from asyncomplete-buffer
    let l:kw = matchstr(a:ctx['typed'], '\w\+$')
    let l:kwlen = len(l:kw)
    if l:kwlen < 1
        return
    endif
    " echom '#completor for ' . l:kw

    let l:params = {
                \ 'name':     a:opt['name'],
                \ 'ctx':      a:ctx,
                \ 'startcol': a:ctx['col'] - l:kwlen,
                \ 'kw':       l:kw,
                \ 'raw':      [],
                \ 'mapped':   []
                \ }

    " Add first empty candidate as incomplete to allow adding more
    " completions later, even if the context changed in between.
    call s:complete(l:params, [''], 1)

    let l:cmd = tmuxcomplete#getcommandlist(l:kw, 'words')
    let l:jobid = async#job#start(l:cmd, {
                \ 'on_stdout': function('s:stdout', [l:params]),
                \ 'on_exit':   function('s:exit',   [l:params]),
                \ })
endfunction

function! s:stdout(params, id, data, event) abort
    " echom '#stdout for ' . a:params['kw'] . ' with ' . (len(a:data) < 5 ? string(a:data) : string(a:data[0 : 1]) . ' ..' . len(a:data) . '.. ' . string(a:data[-2 : -1]))

    call extend(a:params['raw'], a:data) " to be mapped differently again on exit

    " surround with pipes while incomplete
    call extend(a:params['mapped'], map(copy(a:data), '{"word":v:val,"menu":"|' . a:params['name'] . '|"}'))
    call s:complete(a:params, a:params['mapped'], 1)
endfunction

function! s:exit(params, id, data, event) abort
    " echom '#exit for ' . a:params['kw'] . ' with ' . a:data

    if a:data != 0 " command failed
        " echom 'failed with ' . a:data
        " set candidates as complete to stop completing on context changes
        call s:complete(a:params, [''], 0)
        return
    endif

    " surround with brackends when complete
    let l:mapped = map(a:params['raw'], '{"word":v:val,"menu":"[' . a:params['name'] . ']"}')
    call s:complete(a:params, l:mapped, 0)
endfunction

function! s:complete(params, candidates, incomplete)
    call asyncomplete#complete(a:params['name'], a:params['ctx'], a:params['startcol'], a:candidates, a:incomplete)
endfunction
