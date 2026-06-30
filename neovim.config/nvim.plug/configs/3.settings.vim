"Basic settings {{{
    set expandtab
    set shiftwidth=2
    set tabstop=2
    set smartindent
    set smarttab

    set ignorecase
    set smartcase
    set hlsearch
    set incsearch

    set wildmode=longest:full
    set wildmenu
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.idea/*,*/.DS_Store,*/vendor,*/node_modules

    set foldmethod=marker

    set backupcopy=yes

    syntax on
    filetype on
    filetype plugin indent on

    "Don't allow NVIM to set cursor shape
    let $NVIM_TUI_ENABLE_CURSOR_SHAPE = 0
    set guicursor=

    "Disable mouse
    set mouse=""

    "Use relative line numbers for all lines...
    set relativenumber
    "...except the current line
    set number

    "Scheme available 'gruvbox', 'molokai256'
    "let g:airline_theme=onedark
    try
      colorscheme gruvbox
    catch /^Vim\%((\a\+)\)\=:E185/
      colorscheme default
    endtry
"}}}

"Key mappings {{{
    let mapleader=","

    nmap <Leader>p :Files<CR>
    nmap <Leader>o :Buffers<CR>
    nmap <Leader>l :Lines<CR>

    "Make ctrl-l clear highlights
    nnoremap <c-l> :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

    nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
    nnoremap <silent> gd :call LanguageClient#textDocument_definition()<CR>
    nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>

    imap jj <Esc>

    set hidden
    nnoremap <C-N> :bnext<CR>
    nnoremap <C-P> :bprev<CR>
"}}}

"Statusline {{{
    hi User1 ctermbg=black   ctermfg=white   guibg=darkgrey  guifg=white
    hi User2 ctermbg=black   ctermfg=grey    guibg=darkgrey  guifg=grey

    set laststatus=2
    set statusline+=%1*
    set statusline+=%F\ 
    set statusline+=%2*
    set statusline+=%m%r
    set statusline+=%y
    set statusline+=%{fugitive#statusline()}
    set statusline+=%=
    set statusline+=%10((%l,%c)%)\ 
    set statusline+=%P
    set statusline+=%{FugitiveStatusline()}
"}}}

"Misc {{{
    set list
    set listchars=nbsp:…,tab:▸\ ,trail:·

    "Disable background color erase
    set t_ut=
"}}}

"NERDTree {{{
    map <C-b> :NERDTreeToggle<CR>
    map <C-i> :NERDTreeFind<CR>
    let g:NERDTreePatternMatchHighlightFullName = 1
    let NERDTreeAutoDeleteBuffer = 1
    let NERDTreeMinimalUI = 1
    let NERDTreeDirArrows = 1
    let g:NERDDefaultAlign = 'left'
    let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }
    let g:NERDTreeChDirMode=2
    let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__', 'node_modules']
    let g:NERDTreeShowBookmarks=1

"}}}
