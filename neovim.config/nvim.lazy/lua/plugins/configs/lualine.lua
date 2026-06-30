-- Custom components
local function lsp_progress()
  local messages = vim.lsp.util.get_progress_messages()
  if #messages == 0 then
    return ''
  end
  local status = {}
  for _, msg in pairs(messages) do
    local title = msg.title or ''
    local percentage = msg.percentage or 0
    if percentage > 0 then
      table.insert(status, string.format('%s (%.0f%%)', title, percentage))
    else
      table.insert(status, title)
    end
  end
  return table.concat(status, ' | ')
end

local function active_formatters()
  local buf_ft = vim.bo.filetype
  local formatters = require('conform').list_formatters(0)
  if #formatters == 0 then
    return ''
  end
  local names = {}
  for _, formatter in ipairs(formatters) do
    table.insert(names, formatter.name)
  end
  return '󰷈 ' .. table.concat(names, ', ')
end

local function macro_recording()
  local recording_register = vim.fn.reg_recording()
  if recording_register == '' then
    return ''
  else
    return '󰑋 @' .. recording_register
  end
end

require('lualine').setup({
  options = {
    icons_enabled = true,
    theme = 'auto',
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = false,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    },
  },
  sections = {
    lualine_a = { 'mode', macro_recording },
    lualine_b = {
      {
        'branch',
        icon = '',
      },
      'diff',
      'diagnostics',
    },
    lualine_c = { 'filename', lsp_progress },
    lualine_x = { active_formatters, 'encoding', 'fileformat', 'filetype' },
    lualine_y = { 'progress' },
    lualine_z = { 'location' },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { 'filename' },
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},
})
