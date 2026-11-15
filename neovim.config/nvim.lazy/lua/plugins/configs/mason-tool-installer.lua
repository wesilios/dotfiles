-- Only DAP adapters are auto-installed; LSPs/formatters are managed via :Mason
require('mason-tool-installer').setup({
  ensure_installed = {
    'codelldb', -- C/C++ debug adapter
    'netcoredbg', -- C# debug adapter
  },
  run_on_start = true,
  start_delay = 3000,
})
