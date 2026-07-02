local gitsigns = require('gitsigns')
local map = vim.keymap.set

gitsigns.setup({
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
    untracked = { text = '┆' },
  },

  current_line_blame = false,
  on_attach = function(bufnr)
    map('n', ']g', function()
      vim.schedule(function()
        gitsigns.next_hunk()
      end)
    end, { buffer = bufnr, desc = 'Git Next Hunk' })

    map('n', '[g', function()
      vim.schedule(function()
        gitsigns.prev_hunk()
      end)
    end, { buffer = bufnr, desc = 'Git Previous Hunk' })

    map('n', '<leader>ghp', gitsigns.preview_hunk, { buffer = bufnr, desc = 'Git Preview Hunk' })
    map('n', '<leader>ghs', gitsigns.stage_hunk, { buffer = bufnr, desc = 'Git Stage Hunk' })
    map('n', '<leader>ghr', gitsigns.reset_hunk, { buffer = bufnr, desc = 'Git Reset Hunk' })
    map('n', '<leader>ghu', gitsigns.undo_stage_hunk, { buffer = bufnr, desc = 'Git Undo Stage Hunk' })
    map('n', '<leader>ghS', gitsigns.stage_buffer, { buffer = bufnr, desc = 'Git Stage Buffer' })
    map('n', '<leader>ghR', gitsigns.reset_buffer, { buffer = bufnr, desc = 'Git Reset Buffer' })
  end,
})
