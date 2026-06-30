-- ============================================================================
-- Centralized Filetype Settings for Indentation and Column Width
-- ============================================================================
-- This file contains all indentation and column width settings for different
-- file types. Modify these values to change behavior across the entire config.
-- ============================================================================

local M = {}

-- ============================================================================
-- GLOBAL SETTINGS (can be overridden per filetype)
-- ============================================================================
M.defaults = {
  -- Maximum column width for all files (visual guide)
  textwidth = 120,
  colorcolumn = '120',
  
  -- Default indentation (for filetypes not explicitly configured)
  default_indent = 4,
}

-- ============================================================================
-- FILETYPE-SPECIFIC INDENTATION SETTINGS
-- ============================================================================
-- Define indent width for each filetype or group of filetypes
-- These settings will be applied via autocmds
M.indent_settings = {
  -- 2 spaces indent
  ['2_spaces'] = {
    indent = 2,
    filetypes = {
      'lua',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'json',
      'json5',
      'html',
      'css',
      'scss',
      'yaml',
      'yml',
      'markdown',
      'vue',
      'tsx',
      'jsx',
    },
  },
  
  -- 4 spaces indent
  ['4_spaces'] = {
    indent = 4,
    filetypes = {
      'cs',           -- C#
      'c',
      'cpp',
      'h',
      'hpp',
      'cmake',
      'python',
      'java',
      'go',
      'rust',
      'php',
      'ruby',
      'sh',
      'bash',
      'zsh',
      'vim',
      'sql',
      'proto',
    },
  },
}

-- ============================================================================
-- FILETYPE-SPECIFIC COLUMN WIDTH OVERRIDES
-- ============================================================================
-- Override the default textwidth for specific filetypes if needed
M.textwidth_overrides = {
  -- Example: python = 88,  -- PEP 8 recommends 79, but Black uses 88
  -- Example: markdown = 80,
  -- Add more overrides as needed
}

-- ============================================================================
-- APPLY SETTINGS FUNCTION
-- ============================================================================
function M.setup()
  -- Create autocommand group
  local group = vim.api.nvim_create_augroup('FiletypeSettings', { clear = true })
  
  -- Apply settings for each indent group
  for group_name, config in pairs(M.indent_settings) do
    for _, ft in ipairs(config.filetypes) do
      vim.api.nvim_create_autocmd('FileType', {
        group = group,
        pattern = ft,
        callback = function()
          -- Set indentation
          vim.opt_local.shiftwidth = config.indent
          vim.opt_local.tabstop = config.indent
          vim.opt_local.softtabstop = config.indent
          vim.opt_local.expandtab = true
          
          -- Set textwidth (use override if exists, otherwise use default)
          local tw = M.textwidth_overrides[ft] or M.defaults.textwidth
          vim.opt_local.textwidth = tw
          vim.opt_local.colorcolumn = tostring(tw)
        end,
      })
    end
  end
  
  -- Set global defaults for filetypes not explicitly configured
  vim.opt.textwidth = M.defaults.textwidth
  vim.opt.colorcolumn = M.defaults.colorcolumn
end

return M

