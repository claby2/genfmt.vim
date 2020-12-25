# genfmt.vim

Generic code formatting utility. 
This vim plugin utilizes user-defined external tools to format code.

## Getting Started

### Installation

It is recommended that you use a plugin manager to install.

This example uses vim-plug.

#### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
call plug#begin()
Plug 'claby2/genfmt.vim'
call plug#end()
```

## Usage

-   `:GenfmtFormat`
    -   Format the current buffer

### Defining Formatters

`genfmt.vim` works by running an external tool and replacing the current buffer with its standard output.
External tools must be defined and correlated with a corresponding filetype (`&filetype`).

Example configuration:

```vim
let g:genfmt_formatters = {
            \ 'python': "yapf",
            \ 'cpp': "clang-format --style=\"{BasedOnStyle: Google, IndentWidth: 4}\"",
            \ }
```

In this example, if the formatter is run in a python file, it would run [`yapf`](https://github.com/google/yapf).
Likewise, the formatter would run [`clang-format`](https://clang.llvm.org/docs/ClangFormat.html) with the given style argument in a cpp file. 

### Custom Vim Function

Defining a custom vim function that returns the formatter command used allows for additional control if you wish to do so.
For example, specifying the name of the file may influence the output of some formatters.

Example:

```vim
function! ClangFormat()
    return "clang-format --assume-filename=".expand('%:t')." -style=file"
endfunction

let g:genfmt_formatters = {
            \ 'cpp': "ClangFormat()",
            \ }
```

The `ClangFormat()` function returns a command with an argument (`assume-filename`) specifying the name of the file that will be formatted.

When defining the formatter under `genfmt_formatters`, it is important to pass the name of the function with `()` at the end of the string.

### Fallback Formatters

In the case where no formatter is found for the filetype, `genfmt.vim` can format the code by indenting, retabbing, and removing trailing whitespace.
To enable this, set the following variable to 1 (default value is 0).

```vim
let g:genfmt_enable_fallback = 1
```

Additionally, you can define custom commands to run as a fallback.
The following represents the default commands.

```vim
let g:genfmt_fallback = ["%s/\\s\\+$//e", "retab", "normal! gg=G"]
```

When the fallback formatter is called, the commands in `g:genfmt_fallback` will be silently executed.
