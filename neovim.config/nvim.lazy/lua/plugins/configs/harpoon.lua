local harpoon = require('harpoon')

-- REQUIRED
harpoon.setup()
-- REQUIRED

local map = vim.keymap.set

map('n', '<leader>h', function()
  harpoon:list():add()
end, { desc = 'Harpoon add' })

map('n', '<leader>H', function()
  harpoon.ui:toggle_quick_menu(harpoon:list())
end, { desc = 'Harpoon quick menu' })

--map("n", "<C-h>", function() harpoon:list():select(1) end)
--map("n", "<C-t>", function() harpoon:list():select(2) end)
--map("n", "<C-n>", function() harpoon:list():select(3) end)
--map("n", "<C-s>", function() harpoon:list():select(4) end)

-- Toggle previous & next buffers stored within Harpoon list
map('n', '<C-S-P>', function()
  harpoon:list():prev()
end, { desc = 'Harpoon prev buffer' })

map('n', '<C-S-N>', function()
  harpoon:list():next()
end, { desc = 'Harpoon next buffer' })

-- Go to item by index
for i = 1, 9 do
  map('n', '<leader>h' .. i, function()
    harpoon:list():select(i)
  end, { desc = 'Harpoon go to item by index ' .. i })
end
