-- ============================================================================
-- HELP SYSTEM TELESCOPE INTEGRATION
-- ============================================================================
-- Interactive Telescope pickers for browsing config documentation
--
-- Keymaps:
--   <leader>fhk - Find keymaps (Telescope)
--   <leader>fhp - Find plugins (Telescope)
--   <leader>fhl - Find LSP servers (Telescope)
--   <leader>fhf - Find formatters (Telescope)
--   <leader>fho - Find vim settings (Telescope)
-- ============================================================================

local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local conf = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local previewers = require('telescope.previewers')
local map = vim.keymap.set

local M = {}

-- ============================================================================
-- KEYMAP PICKER
-- ============================================================================

function M.keymaps(opts)
  opts = opts or {}

  local help_system = require('core.help-system')
  help_system.load()
  local keymaps = help_system.get_keymaps()

  pickers
    .new(opts, {
      prompt_title = 'Keymaps',
      finder = finders.new_table({
        results = keymaps,
        entry_maker = function(entry)
          return {
            value = entry,
            display = string.format('[%s] %-20s - %s', entry.mode, entry.key, entry.desc),
            ordinal = entry.key .. ' ' .. entry.desc .. ' ' .. entry.mode,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = previewers.new_buffer_previewer({
        title = 'Keymap Details',
        define_preview = function(self, entry)
          local lines = {
            'Keymap Details',
            '==============',
            '',
            'Key:         ' .. entry.value.key,
            'Mode:        ' .. entry.value.mode,
            'Description: ' .. entry.value.desc,
            'Source:      ' .. entry.value.source,
          }
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        end,
      }),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          print(string.format('[%s] %s - %s', selection.value.mode, selection.value.key, selection.value.desc))
        end)
        return true
      end,
    })
    :find()
end

-- ============================================================================
-- PLUGIN PICKER
-- ============================================================================

function M.plugins(opts)
  opts = opts or {}

  local help_system = require('core.help-system')
  help_system.load()
  local plugins = help_system.get_plugins()

  pickers
    .new(opts, {
      prompt_title = 'Plugins',
      finder = finders.new_table({
        results = plugins,
        entry_maker = function(entry)
          return {
            value = entry,
            display = string.format('%-30s (%s)', entry.name, entry.full_name),
            ordinal = entry.name .. ' ' .. entry.full_name,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = previewers.new_buffer_previewer({
        title = 'Plugin Details',
        define_preview = function(self, entry)
          local lines = {
            'Plugin Details',
            '==============',
            '',
            'Name:      ' .. entry.value.name,
            'Full Name: ' .. entry.value.full_name,
            'Source:    ' .. entry.value.source,
          }
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        end,
      }),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          actions.close(prompt_bufnr)
          local selection = action_state.get_selected_entry()
          print(string.format('%s (%s)', selection.value.name, selection.value.full_name))
        end)
        return true
      end,
    })
    :find()
end

-- ============================================================================
-- LSP SERVER PICKER
-- ============================================================================

function M.lsp_servers(opts)
  opts = opts or {}

  local help_system = require('core.help-system')
  help_system.load()
  local lsp_servers = help_system.get_lsp_servers()

  pickers
    .new(opts, {
      prompt_title = 'LSP Servers',
      finder = finders.new_table({
        results = lsp_servers,
        entry_maker = function(entry)
          return {
            value = entry,
            display = entry.name,
            ordinal = entry.name,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = previewers.new_buffer_previewer({
        title = 'LSP Server Details',
        define_preview = function(self, entry)
          local lines = {
            'LSP Server Details',
            '==================',
            '',
            'Name:   ' .. entry.value.name,
            'Source: ' .. entry.value.source,
          }
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        end,
      }),
    })
    :find()
end

-- ============================================================================
-- FORMATTER PICKER
-- ============================================================================

function M.formatters(opts)
  opts = opts or {}

  local help_system = require('core.help-system')
  help_system.load()
  local formatters = help_system.get_formatters()

  pickers
    .new(opts, {
      prompt_title = 'Formatters',
      finder = finders.new_table({
        results = formatters,
        entry_maker = function(entry)
          return {
            value = entry,
            display = string.format('%-20s (filetype: %s)', entry.name, entry.filetype),
            ordinal = entry.name .. ' ' .. entry.filetype,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = previewers.new_buffer_previewer({
        title = 'Formatter Details',
        define_preview = function(self, entry)
          local lines = {
            'Formatter Details',
            '=================',
            '',
            'Name:     ' .. entry.value.name,
            'Filetype: ' .. entry.value.filetype,
            'Source:   ' .. entry.value.source,
          }
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        end,
      }),
    })
    :find()
end

-- ============================================================================
-- SETTINGS PICKER
-- ============================================================================

function M.settings(opts)
  opts = opts or {}

  local help_system = require('core.help-system')
  help_system.load()
  local settings = help_system.get_settings()

  pickers
    .new(opts, {
      prompt_title = 'Vim Settings',
      finder = finders.new_table({
        results = settings,
        entry_maker = function(entry)
          local display_text = string.format('%-20s = %s', entry.name, entry.value)
          if entry.description then
            display_text = display_text .. '  -- ' .. entry.description
          end
          return {
            value = entry,
            display = display_text,
            ordinal = entry.name .. ' ' .. (entry.description or ''),
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = previewers.new_buffer_previewer({
        title = 'Setting Details',
        define_preview = function(self, entry)
          local lines = {
            'Setting Details',
            '===============',
            '',
            'Name:  ' .. entry.value.name,
            'Value: ' .. entry.value.value,
          }
          if entry.value.description then
            table.insert(lines, 'Description: ' .. entry.value.description)
          end
          table.insert(lines, 'Source: ' .. entry.value.source)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
        end,
      }),
    })
    :find()
end

-- ============================================================================
-- KEYMAPS
-- ============================================================================

map('n', '<leader>fhk', function()
  M.keymaps(require('telescope.themes').get_dropdown({}))
end, { desc = 'Find keymaps (Telescope)' })

map('n', '<leader>fhp', function()
  M.plugins(require('telescope.themes').get_dropdown({}))
end, { desc = 'Find plugins (Telescope)' })

map('n', '<leader>fhl', function()
  M.lsp_servers(require('telescope.themes').get_dropdown({}))
end, { desc = 'Find LSP servers (Telescope)' })

map('n', '<leader>fhf', function()
  M.formatters(require('telescope.themes').get_dropdown({}))
end, { desc = 'Find formatters (Telescope)' })

map('n', '<leader>fho', function()
  M.settings(require('telescope.themes').get_dropdown({}))
end, { desc = 'Find vim settings (Telescope)' })

return M
