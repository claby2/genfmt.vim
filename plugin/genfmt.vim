if exists("g:loaded_genfmt")
    finish
endif

if !exists('g:genfmt_formatters')
    let g:genfmt_formatters = {}
endif

if !exists('g:genfmt_enable_fallback')
    let g:genfmt_enable_fallback = 0
endif

if !exists('g:genfmt_fallback')
    let g:genfmt_fallback = ['%s/\\s\\+$//e', 'retab', 'normal! gg=G']
endif

function! s:Warn(message) abort
    echohl WarningMsg |
                \ echomsg a:message |
                \ echohl None
endfunction

function! s:Fallback() abort
    if empty(g:genfmt_fallback) == 0
        let view = winsaveview()
        let search = @/
        for command in g:genfmt_fallback
            silent! execute command
        endfor
        call winrestview(view)
        let @/ = search
    endif
endfunction

function! s:RunFormatter(ftype) abort
    let command = g:genfmt_formatters[a:ftype]
    " Check if command string has '()' at the end and exists as a function
    if command[-2:-1] == '()' && exists('*'.command)
        " Make command take the value of the result of the called function
        let command = call(command[0:-3], [], {})
    endif
    let stdin = getbufline(bufnr('%'), 1, '$')
    let stdin_str = join(stdin, "\n")
    let stdout = split(system(command, stdin_str), "\n")
    let success = index([0], v:shell_error) != -1
    if success
        if stdout !=# stdin
            let view = winsaveview()
            if line('$') > len(stdout)
                silent! execute len(stdout).',$delete' '_'
            endif
            call setline(1, stdout)
            echo "Formatted with '".command."'"
            call winrestview(view)
        else
            echo "No change necessary with '".command."'"
        endif

    else
        call s:Warn("WARNING: Formatter failed to run with '".command."'")
    endif
endfunction

function! s:Format() abort
    let ftype = &filetype
    if has_key(g:genfmt_formatters, ftype)
        " Filetype formatter exists
        call s:RunFormatter(ftype)
    else
        " No formatter for filetype exists
        if g:genfmt_enable_fallback == 1
            call s:Fallback()
            call s:Warn('WARNING: Formatted with fallback formatter')
        else
            call s:Warn("WARNING: No formatters defined for filetype '".ftype."'")
        endif
    endif
endfunction

command! GenfmtFormat call s:Format()

let g:loaded_genfmt = 1
