local comment = require('Comment')

-- Setup Comment.nvim with default settings
comment.setup({
  -- Add a space between comment and the line
  padding = true,

  -- Whether the cursor should stay at its position
  sticky = true,

  -- Lines to be ignored while (un)comment
  ignore = '^$', -- Ignore empty lines

  -- LHS of toggle mappings in NORMAL mode
  toggler = {
    line = 'gcc', -- Line-comment toggle keymap
    block = 'gbc', -- Block-comment toggle keymap
  },

  -- LHS of operator-pending mappings in NORMAL and VISUAL mode
  opleader = {
    line = 'gc', -- Line-comment keymap
    block = 'gb', -- Block-comment keymap
  },

  -- LHS of extra mappings
  extra = {
    above = 'gcO', -- Add comment on the line above
    below = 'gco', -- Add comment on the line below
    eol = 'gcA', -- Add comment at the end of line
  },

  -- Enable keybindings
  -- NOTE: If given `false` then the plugin won't create any mappings
  mappings = {
    basic = true, -- Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
    extra = true, -- Extra mapping; `gco`, `gcO`, `gcA`
  },

  -- Function to call before (un)comment
  pre_hook = nil,

  -- Function to call after (un)comment
  post_hook = nil,
})

-- Additional keymaps with descriptions for which-key
local map = vim.keymap.set

-- Normal mode
map('n', 'gcc', '<Plug>(comment_toggle_linewise_current)', { desc = 'Toggle comment line' })
map('n', 'gbc', '<Plug>(comment_toggle_blockwise_current)', { desc = 'Toggle comment block' })

-- Visual mode
map('x', 'gc', '<Plug>(comment_toggle_linewise_visual)', { desc = 'Toggle comment (linewise)' })
map('x', 'gb', '<Plug>(comment_toggle_blockwise_visual)', { desc = 'Toggle comment (blockwise)' })

-- Extra mappings
map('n', 'gco', '<Plug>(comment_toggle_linewise)o', { desc = 'Comment line below' })
map('n', 'gcO', '<Plug>(comment_toggle_linewise)O', { desc = 'Comment line above' })
map('n', 'gcA', '<Plug>(comment_toggle_linewise)$', { desc = 'Comment end of line' })

