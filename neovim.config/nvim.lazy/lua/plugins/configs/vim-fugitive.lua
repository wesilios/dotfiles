local map = vim.keymap.set

-- Git status
map('n', '<leader>gs', vim.cmd.Git, { desc = 'Git Status' })

-- Git blame
map('n', '<leader>gb', function()
  vim.cmd('Git blame')
end, { desc = 'Git Blame' })

-- Git diff
map('n', '<leader>gd', function()
  vim.cmd('Gvdiffsplit')
end, { desc = 'Git Diff' })

-- Commit
map('n', '<leader>gc', function()
  vim.cmd('Git commit')
end, { desc = 'Git Commit' })

map('n', '<leader>g?', function()
  vim.cmd('Git') -- open status
  vim.cmd('normal g?') -- show help immediately
end, { desc = 'Fugitive Help' })

-- Key mapping to use telescope
local builtin = require('telescope.builtin')
map('n', '<leader>gS', builtin.git_status, { desc = 'Git Status (Telescope)' })
map('n', '<leader>gB', builtin.git_branches, { desc = 'Git Branches' })
map('n', '<leader>gC', builtin.git_commits, { desc = 'Git Commits' })
map('n', '<leader>gF', builtin.git_files, { desc = 'Git Tracked Files' })
map('n', '<leader>gT', builtin.git_stash, { desc = 'Git Stash' })
