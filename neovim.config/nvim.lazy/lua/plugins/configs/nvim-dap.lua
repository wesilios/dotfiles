local dap = require('dap')

local mason_path = vim.fn.stdpath('data') .. '/mason/packages'
local netcoredbg = mason_path .. 'netcoredbg/netcoredbg'
local codelldb = mason_path .. '/codelldb/extension/adapter/codelldb'
-- local mason_path = vim.fn.stdpath('data') .. '/mason/packages/netcoredbg/netcoredbg'

--- Adapter
local netcoredbg_adapter = {
  type = 'executable',
  command = netcoredbg,
  args = { '--interpreter=vscode' },
}

dap.adapters.netcoredbg = netcoredbg_adapter -- needed for normal debugging
dap.adapters.coreclr = netcoredbg_adapter -- needed for unit test debugging

local codelldb_adapter = {
  type = 'server',
  port = '${port}',
  executable = {
    command = codelldb,
    args = { '--port', '${port}' },
  },
}

dap.adapters.codelldb = codelldb_adapter

dap.configurations.cs = {
  {
    type = 'coreclr',
    name = 'launch - netcoredbg',
    request = 'launch',
    program = function()
      return require('dap-dll-autopicker').build_dll_path()
    end,
    -- justMyCode = false,
    -- stopAtEntry = false,
    -- -- program = function()
    -- --   -- todo: request input from ui
    -- --   return "/path/to/your.dll"
    -- -- end,
    -- env = {
    --   ASPNETCORE_ENVIRONMENT = function()
    --     -- todo: request input from ui
    --     return "Development"
    --   end,
    --   ASPNETCORE_URLS = function()
    --     -- todo: request input from ui
    --     return "http://localhost:5050"
    --   end,
    -- },
    -- cwd = function()
    --   -- todo: request input from ui
    --   return vim.fn.getcwd()
    -- end,
  },
}

--- For c,cpp
local c_cpp_config = {
  {
    name = 'launch c/cpp - codelldb',
    type = 'codelldb',
    request = 'launch',

    program = function()
      local file = vim.fn.expand('%:p')
      local filename = vim.fn.expand('%:t:r')
      local dir = vim.fn.expand('%:p:h')

      local executable = dir .. '/' .. filename

      local command = string.format(
        'gcc %s -Wall -Wextra -std=c17 -g -lm -o %s',
        vim.fn.shellescape(file),
        vim.fn.shellescape(executable)
      )

      local result = vim.fn.system(command)

      if vim.v.shell_error ~= 0 then
        vim.notify('Compilation failed:\n' .. result, vim.log.levels.ERROR)
        return nil
      end

      return executable
    end,

    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}

dap.configurations.c = c_cpp_config
dap.configurations.cpp = c_cpp_config

local map = vim.keymap.set

-- DAP keymappings with descriptions for which-key
map('n', '<F5>', '<Cmd>lua require\'dap\'.continue()<CR>', {
  noremap = true,
  silent = true,
  desc = 'DAP: Continue/Start debugging',
})

map('n', '<F6>', '<Cmd>lua require(\'neotest\').run.run({strategy = \'dap\'})<CR>', {
  noremap = true,
  silent = true,
  desc = 'DAP: Debug nearest test (Neotest)',
})

map('n', '<F9>', '<Cmd>lua require\'dap\'.toggle_breakpoint()<CR>', {
  noremap = true,
  silent = true,
  desc = 'DAP: Toggle breakpoint',
})

map('n', '<F10>', '<Cmd>lua require\'dap\'.step_over()<CR>', {
  noremap = true,
  silent = true,
  desc = 'DAP: Step over',
})

map('n', '<F11>', '<Cmd>lua require\'dap\'.step_into()<CR>', {
  noremap = true,
  silent = true,
  desc = 'DAP: Step into',
})

map('n', '<F8>', '<Cmd>lua require\'dap\'.step_out()<CR>', {
  noremap = true,
  silent = true,
  desc = 'DAP: Step out',
})

map('n', '<leader>dr', '<Cmd>lua require\'dap\'.repl.open()<CR>', {
  noremap = true,
  silent = true,
  desc = 'DAP: Open REPL',
})

map('n', '<leader>dl', '<Cmd>lua require\'dap\'.run_last()<CR>', {
  noremap = true,
  silent = true,
  desc = 'DAP: Run last configuration',
})

map('n', '<leader>dt', '<Cmd>lua require(\'neotest\').run.run({strategy = \'dap\'})<CR>', {
  noremap = true,
  silent = true,
  desc = 'DAP: Debug nearest test',
})
