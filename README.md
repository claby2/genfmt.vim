# genfmt.vim

Generic code formatting utility. 
This vim plugin utilizes user-defined external tools to format code.

## Getting Started

### Installation

It is recommended that you use a plugin manager (such as [vim-plug](https://github.com/junegunn/vim-plug) to install.

#### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
call plug#begin()
Plug 'claby2/genfmt.vim'
call plug#end()
```

## Usage

-   `:GenfmtFormat`
    -   Format the current buffer

`genfmt.vim` works by running an external tool and replacing the current buffer with its output.
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
