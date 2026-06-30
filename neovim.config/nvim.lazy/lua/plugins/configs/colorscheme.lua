local map = vim.keymap.set

map('n', '<leader>cl', function()
  -- Ask user for the theme
  local theme = vim.fn.input('Theme (gruvbox/tokyonight/rosepine): ')
  if theme == '' then
    print('Cancelled')
    return
  end

  local switch = {
    gruvbox = function()
      return vim.fn.input('Mode (dark/light): ')
    end,
    tokyonight = function()
      return vim.fn.input('Mode (moon/storm/night/day): ')
    end,
    rosepine = function()
      return vim.fn.input('Mode (main/moon/dawn): ')
    end,
  }

  -- Ask user for the mode/variant
  local ask_mode = switch[theme]

  local mode = nil

  if ask_mode then
    mode = ask_mode()
  else
    print('Unknow theme: ' .. theme)
    return
  end

  -- Call your global function
  SwitchColorScheme(theme, mode)
end, { desc = 'Change Color Scheme' })

-- Theme class
local M = {}

function M.switchtogruvbox(mode)
  local gruvbox = require('gruvbox')

  if mode == 'light' then
    vim.o.background = 'light'
  else
    vim.o.background = 'dark'
  end

  gruvbox.setup({
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = true,
    italic = {
      strings = true,
      emphasis = true,
      comments = true,
      operators = false,
      folds = true,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    inverse = true, -- invert background for search, diffs, statuslines and errors
    contrast = '', -- can be "hard", "soft" or empty string
    palette_overrides = {},
    overrides = {},
    dim_inactive = false,
    transparent_mode = false,
  })
  vim.cmd('colorscheme gruvbox')
end

function M.switchtotokyonight(mode)
  local scheme_map = {
    moon = 'tokyonight-moon',
    storm = 'tokyonight-storm',
    night = 'tokyonight-night',
    day = 'tokyonight-day',
  }

  color = scheme_map[mode] or 'tokyonight'

  vim.cmd('colorscheme ' .. color)
end

function M.switchtorosepine(variant)
  local rosepine = require('rose-pine')

  variant = variant or 'auto'

  local scheme_map = {
    auto = 'rose-pine',
    main = 'rose-pine-main',
    moon = 'rose-pine-moon',
    dawn = 'rose-pine-dawn',
  }

  local scheme = scheme_map[variant] or 'rose-pine'

  rosepine.setup({
    variant = variant, -- "auto", "main", "moon", "dawn"
    dark_variant = 'main',
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    enable = {
      terminal = true,
      legacy_highlights = true,
      migrations = true,
    },

    styles = {
      bold = true,
      italic = true,
      transparency = false,
    },

    groups = {
      border = 'muted',
      link = 'iris',
      panel = 'surface',
      error = 'love',
      hint = 'iris',
      info = 'foam',
      note = 'pine',
      todo = 'rose',
      warn = 'gold',
      git_add = 'foam',
      git_change = 'rose',
      git_delete = 'love',
      git_dirty = 'rose',
      git_ignore = 'muted',
      git_merge = 'iris',
      git_rename = 'pine',
      git_stage = 'iris',
      git_text = 'rose',
      git_untracked = 'subtle',
      h1 = 'iris',
      h2 = 'foam',
      h3 = 'rose',
      h4 = 'gold',
      h5 = 'pine',
      h6 = 'foam',
    },
  })

  vim.cmd('colorscheme ' .. scheme)
end

-- GLOBAL FUNCTION
function _G.SwitchColorScheme(theme, mode)
  local switch = {
    gruvbox = function()
      M.switchtogruvbox(mode)
    end,
    tokyonight = function()
      M.switchtotokyonight(mode)
    end,
    rosepine = function()
      M.switchtorosepine(mode)
    end,
  }

  local case = switch[theme]
  if case then
    case()
  else
    M.switchtorosepine('auto')
  end
end

return M
