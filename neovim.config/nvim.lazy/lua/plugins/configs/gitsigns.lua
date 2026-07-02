local gitsigns = require('gitsigns')

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
    local map = function(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, {
        buffer = bufnr,
        desc = desc,
      })
    end

    -- Navigate hunks (wrapped in vim.schedule)
    map(']g', function()
      vim.schedule(function()
        gitsigns.next_hunk()
      end)
    end, 'Git Next Hunk')

    map('[g', function()
      vim.schedule(function()
        gitsigns.prev_hunk()
      end)
    end, 'Git Previous Hunk')

    map('<leader>ghp', gitsigns.preview_hunk, 'Git Preview Hunk')
    map('<leader>ghs', gitsigns.stage_hunk, 'Git Stage Hunk')
    map('<leader>ghr', gitsigns.reset_hunk, 'Git Reset Hunk')
    map('<leader>ghu', gitsigns.undo_stage_hunk, 'Git Undo Stage Hunk')
    map('<leader>ghS', gitsigns.stage_buffer, 'Git Stage Buffer')
    map('<leader>ghR', gitsigns.reset_buffer, 'Git Reset Buffer')
  end,
})
