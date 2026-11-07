-- nvim-treesitter (main branch rewrite). Requires Neovim 0.12+ and the `tree-sitter` CLI
-- (`npm i -g tree-sitter-cli` or your package manager) to compile parsers.
local ts = require('nvim-treesitter')

ts.setup({
  install_dir = vim.fn.stdpath('data') .. '/site',
})

-- Parsers to keep installed (no-op for the ones already present)
local parsers = {
  'c',
  'cpp',
  'cmake',
  'lua',
  'vim',
  'vimdoc',
  'query',
  'markdown',
  'markdown_inline',
  'javascript',
  'typescript',
  'c_sharp',
  'proto',
  'sql',
  'ssh_config',
  'bash',
  'razor',
  'css',
  'html',
  'json',
  'json5',
  'vue',
  'dockerfile',
}

if vim.fn.executable('tree-sitter') == 1 then
  ts.install(parsers)
else
  vim.notify_once('nvim-treesitter: `tree-sitter` CLI not found, parsers will not be installed', vim.log.levels.WARN)
end

-- Highlighting is no longer automatic on main: start it per buffer when a parser exists
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('TreesitterStart', { clear = true }),
  callback = function(args)
    local lang = vim.treesitter.language.get_lang(args.match) or args.match
    if pcall(vim.treesitter.start, args.buf, lang) then
      return
    end
    -- Parser missing: install it on demand (async) when possible
    if vim.fn.executable('tree-sitter') == 1 and vim.tbl_contains(ts.get_available(), lang) then
      ts.install({ lang })
    end
  end,
})

vim.keymap.set({ 'n', 'v' }, '`', '<Cmd>InspectTree<CR>', { desc = 'Toggle TS inspect tree' })
