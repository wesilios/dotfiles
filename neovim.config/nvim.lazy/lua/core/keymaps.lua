vim.g.mapleader = ' '

local map = vim.keymap.set

map('n', '<leader>pv', vim.cmd.Ex, { desc = 'Explore folder' })
map('n', '<leader>o', 'o<Esc>', { desc = 'Insert empty line below curor' })
map('n', '<leader>O', 'O<Esc>', { desc = 'Insert empty line above curor' })
map('n', '<leader>w', ':w<CR>', { desc = 'Save file' })
map('n', '<leader>wq', ':wq<CR>', { desc = 'Save & Quit' })
map('n', '<leader>q', ':q<CR>', { desc = 'Quit' })

-- Normal mode line movement
map('n', '<A-j>', ':m .+1<CR>==')
map('n', '<A-k>', ':m .-2<CR>==')

-- Visual mode line movement
map('v', '<A-j>', ':m \'>+1<CR>gv=gv')
map('v', '<A-k>', ':m \'<-2<CR>gv=gv')

--map('n', '<Tab>', function()
--  print('Test')
--end)
