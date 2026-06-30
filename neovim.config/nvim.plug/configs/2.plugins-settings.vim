"Plugin settings {{{
    "Enable vim-jsx also for .js files
    let g:jsx_ext_required = 0

    "Disable folding for markdown files
    let g:vim_markdown_folding_disabled = 1

    let g:LanguageClient_serverCommands = {
    \ 'javascript': ['javascript-typescript-stdio']
    \ }

    "CoC extensions
    let g:coc_global_extensions = [
          \ 'coc-snippets',
          \ 'coc-rls',
          \ 'coc-pairs'
          \ ]
"}}}
