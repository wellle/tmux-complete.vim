function! s:on_stdout_nvim(job_id, data, event) dict
    let self.output[-1] .= a:data[0]
    call extend(self.output, a:data[1:])
endfunction

function! s:on_exit_nvim(job_id, data, event) dict
    " drop the last (empty) item
    let candidates = self.output[: -2]
    call self.callback(candidates)
endfunction

function! s:on_output_vim(channel, message) dict
    call add(self.output, a:message)
endfunction

function! s:on_exit_vim(job, status) dict
    " drop the first (empty) item
    let candidates = self.output[1 :]
    call self.callback(candidates)
endfunction

function! tmuxcomplete#async#gather_candidates(callback)
    let command = tmuxcomplete#getcommandlist('', 10, 'words')
    let context = {
                \ 'output':   [''],
                \ 'callback': a:callback,
                \ }

    if has('nvim')
        call jobstart(command, {
                    \ 'on_stdout': function('s:on_stdout_nvim', context),
                    \ 'on_exit':   function('s:on_exit_nvim', context),
                    \ })
    else
        call job_start(command, {
                    \ 'out_cb':  function('s:on_output_vim', context),
                    \ 'exit_cb': function('s:on_exit_vim', context),
                    \ })
    endif
endfunction
