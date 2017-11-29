let s:defaultopts = {
            \ 'name':      'tmuxcomplete',
            \ 'whitelist': ['*'],
            \ 'completor': function('asyncomplete#sources#tmuxcomplete#completor'),
            \ }

" 'splitmode' can be 'words', 'lines', 'ilines', or 'linies,words'
" 'ilines' is inner line, starting with a word character (ignoring special
" chararcters in front)
" 'ilines,words' completes both lines and words
" more combinations can be added per request
"
" if 'filter_prefix' is enabled, we will filter candidates based on the entered
" text, this usually gives faster results. for fuzzy matching this should be
" disabled
"
" if there you are using many tmux windows with a lot of text in it completion
" can be slow. that's why we start showing candidates as soon as they come in
" if you prefer to only see candidates once the list is complete, you can
" disable this by setting 'show_incomplete'
"
" 'sort_candidates' controls whether we sort candidates from tmux externally.
" if it's enabled we can't get early incomplete results. if you have
" 'show_incomplete' disabled, this might get slightly quicker results and
" potentially better sorted completions.
"
" if 'scrollback' is positive we will consider that many lines in each tmux
" pane's history for completion
"
" if 'truncate' is positive, then only prefixes of the matches up to this
" length are shown in the completion pop-up. upon selection the full match is
" completed of course
let s:defaultconfig = {
            \ 'splitmode':      'words',
            \ 'filter_prefix':   1,
            \ 'show_incomplete': 1,
            \ 'sort_candidates': 0,
            \ 'scrollback':      0,
            \ 'truncate':        0
            \ }

function! asyncomplete#sources#tmuxcomplete#register(opts)
    let l:opts   = extend(copy(s:defaultopts), a:opts)
    let s:config = extend(copy(s:defaultconfig), get(a:opts, 'config', {}))
    " echom 'config ' . string(s:config)
    let s:abbr = s:config.truncate > 0 ? ',"abbr":v:val[0:' . (s:config.truncate-1) . ']' : ''
    call asyncomplete#register_source(l:opts)
endfunction

function! asyncomplete#sources#tmuxcomplete#completor(opt, ctx)
    " taken from asyncomplete-buffer
    let l:kw = matchstr(a:ctx.typed, '\w\+$')
    let l:kwlen = len(l:kw)
    if l:kwlen < 1
        return
    endif
    " echom '#completor for ' . l:kw

    let l:params = {
                \ 'name':     a:opt.name,
                \ 'ctx':      a:ctx,
                \ 'startcol': a:ctx.col - l:kwlen,
                \ 'kw':       l:kw,
                \ 'raw':      [],
                \ 'mapped':   []
                \ }

    " Add first empty candidate as incomplete to allow adding more
    " completions later, even if the context changed in between.
    call s:complete(l:params, [''], 1)

    if !s:config.filter_prefix
        let l:kw = ''
    endif

    let l:cmd = tmuxcomplete#getcommandlist(l:kw, s:config.scrollback, s:config.splitmode)
    if !s:config.sort_candidates
        call add(l:cmd, '-n')
    endif
    " echom 'cmd ' . string(l:cmd)

    let l:jobid = async#job#start(l:cmd, {
                \ 'on_stdout': function('s:stdout', [l:params]),
                \ 'on_exit':   function('s:exit',   [l:params]),
                \ })
endfunction

function! s:stdout(params, id, data, event) abort
    " echom '#stdout for ' . a:params.kw . ' with ' . (len(a:data) < 5 ? string(a:data) : string(a:data[0 : 1]) . ' ..' . len(a:data) . '.. ' . string(a:data[-2 : -1]))

    call extend(a:params.raw, a:data) " to be mapped differently again on exit

    if s:config.show_incomplete
        " surround with pipes while incomplete
        call extend(a:params.mapped, map(copy(a:data), '{"word":v:val,"menu":"|' . a:params.name . '|"' . s:abbr . '}'))
        call s:complete(a:params, a:params.mapped, 1)
    endif
endfunction

function! s:exit(params, id, data, event) abort
    " echom '#exit for ' . a:params.kw . ' with ' . a:data

    if a:data != 0 " command failed
        " echom 'failed with ' . a:data
        " set candidates as complete to stop completing on context changes
        call s:complete(a:params, [''], 0)
        return
    endif

    " surround with brackends when complete
    let l:mapped = map(a:params.raw, '{"word":v:val,"menu":"[' . a:params.name . ']"' . s:abbr . '}')
    call s:complete(a:params, l:mapped, 0)
endfunction

function! s:complete(params, candidates, incomplete)
    call asyncomplete#complete(a:params.name, a:params.ctx, a:params.startcol, a:candidates, a:incomplete)
endfunction
