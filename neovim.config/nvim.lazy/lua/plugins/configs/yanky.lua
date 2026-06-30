local M = {}

function M.setup()
  local yanky = require('yanky')
  local map = vim.keymap.set

  yanky.setup({
    highlight = { timer = 400 },
    ring = { storage = 'memory' },
    picker = { select = { telescope = true } },
  })

  -- Override default yanks
  map('n', '<C-c>', '<Plug>(YankyYank)', { desc = 'Yank line/selection (Yanky)' })

  -- Smart paste
  map({ 'n', 'v' }, 'p', '<Plug>(YankyPutAfter)', { desc = 'Paste after (Yanky)' })
  map({ 'n', 'v' }, 'P', '<Plug>(YankyPutBefore)', { desc = 'Paste before (Yanky)' })

  -- Cycle through previous yanks
  map('n', ']p', '<Plug>(YankyPreviousEntry)', { desc = 'Yank Previous Entry' })
  map('n', '[p', '<Plug>(YankyNextEntry)', { desc = 'Yank Next Entry' })

  -- Duplicate current line below (Ctrl-d)
  --map('n', '<C-d>', function()
  --  vim.cmd('normal! yy')
  --  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(YankyPutAfter)', true, false, true), 'n', false)
  --end, { desc = 'Duplicate line below (Yanky)' })

  -- Duplicate current line below (Ctrl-Alt-d)
  --map('n', '<C-A-d>', function()
  --  vim.cmd('normal! yy')
  --  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Plug>(YankyPutBefore)', true, false, true), 'n', false)
  --end, { desc = 'Duplicate line below (Yanky)' })

  -- Yank history picker (require telescope)
  map('n', '<leader>yh', function()
    require('telescope').extensions.yank_history.yank_history()
  end, { desc = 'Open Yank history picker' })

  map('n', '<leader>yhc', ':YankyClearHistory<CR>', { desc = 'Yank clear history' })
end

return M
