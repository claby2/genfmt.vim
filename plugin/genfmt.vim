if exists('g:loaded_genfmt')
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

command! GenfmtFormat call genfmt#Format()

let g:loaded_genfmt = 1
