local dap = require('dap')

local mason_path = vim.fn.stdpath('data') .. '/mason/packages'
local netcoredbg = mason_path .. '/netcoredbg/netcoredbg'
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
-- Compile the current file with debug info and return the executable path
local function build_current_file(compiler, flags)
  local file = vim.fn.expand('%:p')
  local executable = vim.fn.expand('%:p:r')

  local command = string.format(
    '%s %s -o %s %s',
    compiler,
    vim.fn.shellescape(file),
    vim.fn.shellescape(executable),
    flags
  )

  local result = vim.fn.system(command)

  if vim.v.shell_error ~= 0 then
    vim.notify('Compilation failed:\n' .. result, vim.log.levels.ERROR)
    return nil
  end

  return executable
end

local function pick_executable()
  return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
end

local function make_configs(compiler, flags)
  return {
    {
      name = 'launch - build current file (codelldb)',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return build_current_file(compiler, flags)
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
    {
      name = 'launch - pick executable (codelldb)',
      type = 'codelldb',
      request = 'launch',
      program = pick_executable,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
    {
      name = 'launch - pick executable with args (codelldb)',
      type = 'codelldb',
      request = 'launch',
      program = pick_executable,
      args = function()
        local input = vim.fn.input('Arguments: ')
        return vim.split(input, ' ', { trimempty = true })
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
    },
    {
      name = 'attach - process (codelldb)',
      type = 'codelldb',
      request = 'attach',
      pid = require('dap.utils').pick_process,
      cwd = '${workspaceFolder}',
    },
  }
end

dap.configurations.c = make_configs('gcc', '-Wall -Wextra -std=c17 -g -O0 -lm')
dap.configurations.cpp = make_configs('g++', '-Wall -Wextra -std=c++20 -g -O0')

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
