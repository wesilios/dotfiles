" =========================
" init.vim
" =========================

" Cross-platform configuration path detection
" Detect OS and set config path accordingly
if has('win32') || has('win64')
  " Windows: Use ~/AppData/Local/nvim
  let g:config_path = expand('~/AppData/Local/nvim')
else
  " Linux/macOS: Use ~/.config/nvim
  let g:config_path = expand('~/.config/nvim')
endif

" Ensure runtimepath includes local config folders
execute 'set runtimepath^=' . g:config_path

" Load all modular configs
let config_files = g:config_path . '/configs/*.vim'
for f in split(glob(config_files), '\n')
  exe 'source' f
endfor

" Optional: load custom colorscheme
colorscheme gruvbox

" Optional: Load Lua entry point if exists (future-proof)
let lua_init = g:config_path . '/lua/init_lua.lua'
if filereadable(expand(lua_init))
  lua require('init_lua')
endif
