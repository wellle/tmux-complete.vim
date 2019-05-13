function! s:on_stdout(job_id, data, event) dict
    let self.output[-1] .= a:data[0]
    call extend(self.output, a:data[1:])
endfunction

function! s:on_exit(job_id, data, event) dict
    " drop the last (empty) item
    let candidates = self.output[1 : -2]
    call self.callback(candidates)
endfunction

function! tmuxcomplete#async#gather_candidates(callback)
    let command = tmuxcomplete#getcommandlist('', 10, 'words')
    let context = {
                \ 'output':   [''],
                \ 'callback': a:callback,
                \ }
    let job_id = jobstart(command, {
                \ 'on_stdout': function('s:on_stdout', context),
                \ 'on_exit':   function('s:on_exit', context),
                \ })
endfunction
