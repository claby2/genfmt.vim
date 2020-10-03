if exists("g:loaded_genfmt")
    finish
endif

if !exists('g:genfmt_formatters')
    let g:genfmt_formatters = {}
endif

function! s:Warn(message)
    echohl WarningMsg |
                \ echomsg a:message |
                \ echohl None
endfunction

function! s:RunFormatter(ftype)
    let command = g:genfmt_formatters[a:ftype]
    let stdin = getbufline(bufnr('%'), 1, '$')
    let stdin_str = join(stdin, "\n")
    let stdout = split(system(command, stdin_str), '\n')
    let success = index([0], v:shell_error) != -1
    if success
        if stdout !=# stdin
            execute ":%d"
            call setline(1, stdout)
        endif
        echo "Formatted with '".command."'"
    else
        call s:Warn("WARNING: Formatter failed to run with '".command."'")
    endif
endfunction

function! s:Format()
    let ftype = &filetype
    if g:genfmt_formatters->has_key(ftype)
        " Filetype formatter exists
        call s:RunFormatter(ftype)
    else
        " No formatter for filetype exists
        call s:Warn("WARNING: No formatters defined for filetype '".ftype."'")
    endif
endfunction

command! GenfmtFormat call s:Format()

let g:loaded_genfmt = 1
