"Plugins {{{
    call plug#begin()

    "Git integration
    Plug 'tpope/vim-fugitive'

    "Autocompletion
    function! DoRemote(arg)
        UpdateRemotePlugins
    endfunction
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    "Language protocol support
    " Cross-platform installation
    if has('win32') || has('win64')
        Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'powershell -ExecutionPolicy Bypass -File install.ps1'
        \ }
    else
        Plug 'autozimu/LanguageClient-neovim', {
        \ 'branch': 'next',
        \ 'do': 'bash install.sh'
        \ }
    endif

    "Fuzzy file finder
    " Cross-platform installation
    if has('win32') || has('win64')
        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    else
        Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
    endif
    Plug 'junegunn/fzf.vim'

    "Additional syntax detection & highlighting
    Plug 'rust-lang/rust.vim'

    "See editorconfig.org
    Plug 'editorconfig/editorconfig-vim'

    "Sneaky motions
    Plug 'justinmk/vim-sneak'

    "Better JS highlighting & indentation
    Plug 'pangloss/vim-javascript'

    "TypeScript syntax highlighting
    Plug 'leafgarland/typescript-vim'

    "TypeScript completion support
    Plug 'Quramy/tsuquyomi'

    "Syntax checking
    Plug 'w0rp/ale'

    "Async execution for vim (dependency of tsuquyomi)
    " Cross-platform build
    if has('win32') || has('win64')
        Plug 'Shougo/vimproc.vim', { 'do': 'tools\\update-dll-mingw' }
    elseif has('mac')
        Plug 'Shougo/vimproc.vim', { 'do': 'make -f make_mac.mak' }
    else
        Plug 'Shougo/vimproc.vim', { 'do': 'make' }
    endif

    "JSX support
    Plug 'mxw/vim-jsx'

    "CoffeeScript support
    Plug 'kchmck/vim-coffee-script'

    "Haxe support
    Plug 'rf-/vaxe'

    "Improved Markdown support
    Plug 'plasticboy/vim-markdown'

    "ActionScript support
    Plug 'jeroenbourgois/vim-actionscript'

    "Modify surrounding chars, such as parantheses & quotes
    Plug 'tpope/vim-surround'

    "NERDTree
    Plug 'scrooloose/nerdtree'

    "Vim sugar for the UNIX shell commands
    Plug 'tpope/vim-eunuch'

    "Vim bindings for rtags, llvm/clang based c++ code indexer
    Plug 'lyuts/rtags'

    "Theme
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'morhetz/gruvbox'

    "OmiSharp
    Plug 'OmniSharp/omnisharp-vim'

    "Buff tab lines
    Plug 'ap/vim-buftabline'

    "Markdown
    " Cross-platform installation
    if has('win32') || has('win64')
        Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
    else
        Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
    endif

    call plug#end()

"}}}
