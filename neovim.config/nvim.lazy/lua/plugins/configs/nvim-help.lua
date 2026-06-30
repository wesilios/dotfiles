-- ============================================================================
-- HELP SYSTEM CONFIGURATION
-- ============================================================================
-- Lazy-loaded help system that provides self-documentation for your config
--
-- Keymaps:
--   <leader>?k - Show all keymaps
--   <leader>?p - Show all plugins
--   <leader>?l - Show all LSP servers
--   <leader>?f - Show all formatters
--   <leader>?s - Show statistics
--   <leader>?r - Force rescan config files
-- ============================================================================

-- Auto-scan on first load (lazy-loaded)
local help_system = require('core.help-system')

local map = vim.keymap.set

local M = {}

function M.set_keymaps()
  -- Keymaps for help system
  map('n', '<leader>?k', function()
    help_system.load()
    local grouped = help_system.get_keymaps_grouped()

    print('=== Keymaps by Category ===')
    for category, keymaps in pairs(grouped) do
      print(string.format('\n%s (%d):', category, #keymaps))
      for _, km in ipairs(keymaps) do
        print(string.format('  [%s] %-20s - %s', km.mode, km.key, km.desc))
      end
    end
  end, { desc = 'Show all keymaps (grouped)' })

  map('n', '<leader>?p', function()
    help_system.load()
    local plugins = help_system.get_plugins()

    print('=== All Plugins ===')
    for _, p in ipairs(plugins) do
      print(string.format('- %s (%s)', p.name, p.full_name))
    end
    print(string.format('\nTotal: %d plugins', #plugins))
  end, { desc = 'Show all plugins' })

  map('n', '<leader>?l', function()
    help_system.load()
    local lsp_servers = help_system.get_lsp_servers()

    print('=== All LSP Servers ===')
    for _, lsp in ipairs(lsp_servers) do
      print(string.format('- %s', lsp.name))
    end
    print(string.format('\nTotal: %d LSP servers', #lsp_servers))
  end, { desc = 'Show all LSP servers' })

  map('n', '<leader>?f', function()
    help_system.load()
    local formatters = help_system.get_formatters()

    print('=== All Formatters ===')
    local by_filetype = {}
    for _, fmt in ipairs(formatters) do
      if not by_filetype[fmt.filetype] then
        by_filetype[fmt.filetype] = {}
      end
      table.insert(by_filetype[fmt.filetype], fmt.name)
    end

    for ft, fmts in pairs(by_filetype) do
      print(string.format('%s: %s', ft, table.concat(fmts, ', ')))
    end
    print(string.format('\nTotal: %d formatters', #formatters))
  end, { desc = 'Show all formatters' })

  map('n', '<leader>?s', function()
    help_system.print_stats()
  end, { desc = 'Show help system statistics' })

  map('n', '<leader>?r', function()
    help_system.force_rescan()
  end, { desc = 'Force rescan config files' })

  map('n', '<leader>?g', function()
    help_system.generate()
  end, { desc = 'Generate vim help documentation' })

  map('n', '<leader>?o', function()
    help_system.load()
    local settings = help_system.get_settings()

    print('=== Vim Settings ===')
    for _, setting in ipairs(settings) do
      if setting.description then
        print(string.format('%s = %s  -- %s', setting.name, setting.value, setting.description))
      else
        print(string.format('%s = %s', setting.name, setting.value))
      end
    end
    print(string.format('\nTotal: %d settings', #settings))
  end, { desc = 'Show all vim settings' })

  map('n', '<leader>?h', function()
    print('=== Help System ===')
    print('')
    print('Basic Keymaps:')
    print('  <leader>?h - Show this help')
    print('  <leader>?k - Show all keymaps (grouped by category)')
    print('  <leader>?p - Show all plugins')
    print('  <leader>?l - Show all LSP servers')
    print('  <leader>?f - Show all formatters')
    print('  <leader>?o - Show all vim settings')
    print('  <leader>?s - Show statistics')
    print('  <leader>?r - Force rescan config files')
    print('  <leader>?g - Generate vim help documentation (:help nvim-config)')
    print('')
    print('Telescope Pickers (Interactive):')
    print('  <leader>fhk - Find keymaps (Telescope)')
    print('  <leader>fhp - Find plugins (Telescope)')
    print('  <leader>fhl - Find LSP servers (Telescope)')
    print('  <leader>fhf - Find formatters (Telescope)')
    print('  <leader>fho - Find vim settings (Telescope)')
    print('')
    print('Programmatic API:')
    print('  require("core.help-system").load()')
    print('  require("core.help-system").force_rescan()')
    print('  require("core.help-system").get_keymaps()')
    print('  require("core.help-system").get_plugins()')
    print('  require("core.help-system").search_keymaps("query")')
    print('  require("core.help-system").clear_cache()')
    print('')
    print('Cache file: ~/.config/nvim/lua/core/.help-cache.lua')
    print('Documentation: ~/.config/nvim/lua/core/HELP_SYSTEM.md')
  end, { desc = 'Show help system usage' })
end

function M.init()
  M.set_keymaps()
  help_system.load()

  -- Load Telescope integration
  require('plugins.configs.help-telescope')
end

M.keys = {
  { '<leader>?h', desc = 'Show help system usage' },
  { '<leader>?k', desc = 'Show all keymaps (grouped)' },
  { '<leader>?p', desc = 'Show all plugins' },
  { '<leader>?l', desc = 'Show all LSP servers' },
  { '<leader>?f', desc = 'Show all formatters' },
  { '<leader>?o', desc = 'Show all vim settings' },
  { '<leader>?s', desc = 'Show help statistics' },
  { '<leader>?r', desc = 'Force rescan config files' },
  { '<leader>?g', desc = 'Generate vim help documentation' },
  { '<leader>fhk', desc = 'Find keymaps (Telescope)' },
  { '<leader>fhp', desc = 'Find plugins (Telescope)' },
  { '<leader>fhl', desc = 'Find LSP servers (Telescope)' },
  { '<leader>fhf', desc = 'Find formatters (Telescope)' },
  { '<leader>fho', desc = 'Find vim settings (Telescope)' },
}

return M
