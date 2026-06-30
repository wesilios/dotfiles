-- Neovim options
local o = vim.opt

o.number = true
o.relativenumber = true
o.cursorline = true

-- Indentation defaults (will be overridden by filetype-settings.lua)
o.expandtab = true -- Use spaces instead of tabs
o.shiftwidth = 4   -- Default to 4 spaces (overridden per filetype)
o.tabstop = 4      -- Default to 4 spaces (overridden per filetype)
o.softtabstop = 4  -- Default to 4 spaces (overridden per filetype)
o.smartindent = true
o.autoindent = true

-- Column width and wrapping
o.textwidth = 120      -- Maximum line length (overridden per filetype)
o.colorcolumn = '120'  -- Visual guide at column 120
o.wrap = false         -- Don't wrap lines visually
o.linebreak = true     -- If wrap is enabled, break at word boundaries

o.termguicolors = true
o.scrolloff = 8
o.signcolumn = 'yes'

o.clipboard = 'unnamedplus'
o.updatetime = 300
o.timeoutlen = 500
