local map = vim.keymap.set

local wk = require('which-key')

map('n', '<leader>?', function()
  wk.show({ global = false })
end, { desc = 'Buffer local keymaps (which-key)' })
