local dapui = require('dapui')
local dap = require('dap')

--- open ui immediately when debugging starts
dap.listeners.after.event_initialized['dapui_config'] = function()
  dapui.open()
end
dap.listeners.before.event_terminated['dapui_config'] = function()
  dapui.close()
end
dap.listeners.before.event_exited['dapui_config'] = function()
  dapui.close()
end

-- default configuration
dapui.setup()

-- Keymappings for DAP UI
local map = vim.keymap.set

map('n', '<leader>du', function()
  dapui.toggle()
end, { noremap = true, silent = true, desc = 'DAP: Toggle UI' })

map('n', '<leader>de', function()
  dapui.eval()
end, { noremap = true, silent = true, desc = 'DAP: Eval expression' })

map('v', '<leader>de', function()
  dapui.eval()
end, { noremap = true, silent = true, desc = 'DAP: Eval selection' })
