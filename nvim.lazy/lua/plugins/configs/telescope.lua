local builtin = require('telescope.builtin')

local map = vim.keymap.set

map('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
map('n', '<leader>ps', function()
  builtin.grep_string({ search = vim.fn.input('Grep > ') })
end, { desc = 'Grep search? ' })
map('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
map('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
map('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
