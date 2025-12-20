# Help System

Auto-scans your Neovim config to document keymaps, plugins, LSP servers, formatters, and settings.

## Quick Start

```vim
<leader>?h    " Show help
<leader>?k    " Show keymaps (grouped by category)
<leader>fhk   " Find keymaps (Telescope)
<leader>?g    " Generate :help nvim-config
```

## Features

- ✅ **Auto-scanning** - Extracts info from config files automatically
- ✅ **Smart cache** - Only re-scans when files change
- ✅ **Lazy-loaded** - Zero startup impact
- ✅ **Telescope integration** - Interactive fuzzy search
- ✅ **Smart categorization** - Groups keymaps by functionality
- ✅ **Vim help docs** - Generate proper `:help` documentation

## API

```lua
local help = require('core.help-scanner')

-- Get data
help.load()
local keymaps = help.get_keymaps()
local grouped = help.get_keymaps_grouped()
local plugins = help.get_plugins()
local settings = help.get_settings()

-- Search
local results = help.search_keymaps('telescope')

-- Maintenance
help.force_rescan()
help.clear_cache()
```

## How It Works

1. **Scans** config files for patterns (keymaps, plugins, LSP, formatters, settings)
2. **Caches** results to `.help-cache.lua` with file modification times
3. **Loads** from cache on next startup (only re-scans if files changed)
4. **Categorizes** keymaps by functionality (Telescope, Git, LSP, Debug, etc.)

## Extending

Add new scanners in `lua/core/help-scanner.lua`:

```lua
local function scan_all_autocmds()
  -- Your scanning logic
  return autocmds
end

-- Add to scan_all() and create M.get_autocmds()
```

## Troubleshooting

```vim
" Force rescan
<leader>?r

" Check stats
<leader>?s

" Clear cache
:lua require('core.help-scanner').clear_cache()
```

