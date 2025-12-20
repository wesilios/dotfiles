-- ============================================================================
-- HELP SCANNER - Automatic Documentation Extractor with Persistent Cache
-- ============================================================================
-- Scans Neovim config files to extract keymaps, plugins, LSP, formatters, etc.
-- Writes results to a persistent cache file for fast loading.
-- Only re-scans when config files are modified.
--
-- Usage:
--   local help = require('core.help-scanner')
--   help.load()  -- Load from cache (auto-scans if needed)
--   local keymaps = help.get_keymaps()
--   help.force_rescan()  -- Force re-scan and update cache
-- ============================================================================

local M = {}

-- Paths
local config_root = vim.fn.stdpath('config')
local cache_file = config_root .. '/lua/core/.help-cache.lua'

-- In-memory cache (loaded from persistent cache file)
local cache = {
  keymaps = {},
  plugins = {},
  lsp_servers = {},
  formatters = {},
  settings = {},
  metadata = {},
  config_files_mtime = {}, -- Track modification times
  last_scan_time = nil,
}

local is_loaded = false

-- ============================================================================
-- FILE UTILITIES
-- ============================================================================

-- Get file modification time
local function get_mtime(filepath)
  local stat = vim.loop.fs_stat(filepath)
  return stat and stat.mtime.sec or 0
end

-- Read file contents
local function read_file(filepath)
  local file = io.open(filepath, 'r')
  if not file then
    return nil
  end
  local content = file:read('*all')
  file:close()
  return content
end

-- Write content to file
local function write_file(filepath, content)
  local file = io.open(filepath, 'w')
  if not file then
    vim.notify('Failed to write cache file: ' .. filepath, vim.log.levels.ERROR)
    return false
  end
  file:write(content)
  file:close()
  return true
end

-- Get all Lua files in a directory recursively
local function get_lua_files(dir)
  local files = {}
  local handle = vim.loop.fs_scandir(dir)

  if not handle then
    return files
  end

  while true do
    local name, type = vim.loop.fs_scandir_next(handle)
    if not name then
      break
    end

    local path = dir .. '/' .. name

    if type == 'directory' then
      local subfiles = get_lua_files(path)
      for _, f in ipairs(subfiles) do
        table.insert(files, f)
      end
    elseif type == 'file' and name:match('%.lua$') then
      table.insert(files, path)
    end
  end

  return files
end

-- ============================================================================
-- CONFIG FILES TO TRACK
-- ============================================================================

local function get_tracked_files()
  return {
    config_root .. '/lua/core/keymaps.lua',
    config_root .. '/lua/core/options.lua',
    config_root .. '/lua/plugins/init.lua',
    config_root .. '/lua/plugins/configs/lsp.lua',
    config_root .. '/lua/plugins/configs/conform.lua',
    config_root .. '/lua/plugins/configs/telescope.lua',
    config_root .. '/lua/plugins/configs/vim-fugitive.lua',
    config_root .. '/lua/plugins/configs/harpoon.lua',
    config_root .. '/lua/plugins/configs/yanky.lua',
    config_root .. '/lua/plugins/configs/undotree.lua',
    config_root .. '/lua/plugins/configs/colorscheme.lua',
    config_root .. '/lua/plugins/configs/which-key.lua',
    config_root .. '/lua/plugins/configs/comment.lua',
    config_root .. '/lua/plugins/configs/mini-nvim.lua',
    config_root .. '/lua/plugins/configs/nvim-dap.lua',
    config_root .. '/lua/plugins/configs/nvim-dap-ui.lua',
    config_root .. '/lua/plugins/configs/neotest.lua',
    config_root .. '/lua/plugins/configs/roslyn.lua',
    config_root .. '/lua/plugins/configs/help-system.lua',
    config_root .. '/lua/plugins/configs/help-telescope.lua',
  }
end

-- Check if any config files have been modified since last scan
local function config_files_modified()
  local tracked = get_tracked_files()

  for _, filepath in ipairs(tracked) do
    local current_mtime = get_mtime(filepath)
    local cached_mtime = cache.config_files_mtime[filepath] or 0

    if current_mtime > cached_mtime then
      return true
    end
  end

  return false
end

-- Update modification times in cache
local function update_mtimes()
  local tracked = get_tracked_files()
  cache.config_files_mtime = {}

  for _, filepath in ipairs(tracked) do
    cache.config_files_mtime[filepath] = get_mtime(filepath)
  end
end

-- ============================================================================
-- KEYMAP SCANNER
-- ============================================================================

-- Extract keymaps from a file
local function scan_keymaps_in_file(filepath)
  local content = read_file(filepath)
  if not content then
    return {}
  end

  local keymaps = {}
  local relative_path = filepath:gsub(config_root .. '/', ''):gsub('^lua/', '')

  -- Pattern 1: vim.keymap.set('mode', 'key', ..., { desc = 'description' })
  for mode, key, desc in
    content:gmatch(
      [=[vim%.keymap%.set%s*%(%s*['"]([^'"]+)['"]%s*,%s*['"]([^'"]+)['"]%s*,.-desc%s*=%s*['"]([^'"]+)['"]]=]
    )
  do
    table.insert(keymaps, {
      mode = mode,
      key = key,
      desc = desc,
      source = relative_path,
    })
  end

  -- Pattern 2: map() shorthand
  for mode, key, desc in
    content:gmatch([=[map%s*%(%s*['"]([^'"]+)['"]%s*,%s*['"]([^'"]+)['"]%s*,.-desc%s*=%s*['"]([^'"]+)['"]]=])
  do
    table.insert(keymaps, {
      mode = mode,
      key = key,
      desc = desc,
      source = relative_path,
    })
  end

  -- Pattern 3: Multiple modes { 'n', 'v' }
  for modes_str, key, desc in
    content:gmatch(
      [=[vim%.keymap%.set%s*%(%s*{%s*([^}]+)%s*}%s*,%s*['"]([^'"]+)['"]%s*,.-desc%s*=%s*['"]([^'"]+)['"]]=]
    )
  do
    for mode in modes_str:gmatch([=[['"]([^'"]+)['"]]=]) do
      table.insert(keymaps, {
        mode = mode,
        key = key,
        desc = desc,
        source = relative_path,
      })
    end
  end

  return keymaps
end

-- Scan all keymaps from config files
local function scan_all_keymaps()
  local all_keymaps = {}

  -- Scan core keymaps
  local core_dir = config_root .. '/lua/core'
  for _, file in ipairs(get_lua_files(core_dir)) do
    local keymaps = scan_keymaps_in_file(file)
    for _, km in ipairs(keymaps) do
      table.insert(all_keymaps, km)
    end
  end

  -- Scan plugin config keymaps
  local plugins_dir = config_root .. '/lua/plugins/configs'
  for _, file in ipairs(get_lua_files(plugins_dir)) do
    local keymaps = scan_keymaps_in_file(file)
    for _, km in ipairs(keymaps) do
      table.insert(all_keymaps, km)
    end
  end

  return all_keymaps
end

-- ============================================================================
-- PLUGIN SCANNER
-- ============================================================================

-- Scan plugins from plugins/init.lua
local function scan_all_plugins()
  local plugins = {}
  local plugins_file = config_root .. '/lua/plugins/init.lua'
  local content = read_file(plugins_file)

  if not content then
    return plugins
  end

  -- Pattern: { 'author/plugin-name' }
  for plugin_name in content:gmatch([=[{%s*['"]([^'"]+/[^'"]+)['"]]=]) do
    local name = plugin_name:match('/(.+)$') or plugin_name
    table.insert(plugins, {
      full_name = plugin_name,
      name = name,
      source = 'plugins/init.lua',
    })
  end

  return plugins
end

-- ============================================================================
-- LSP SCANNER
-- ============================================================================

-- Scan LSP servers from lsp.lua
local function scan_all_lsp_servers()
  local lsp_servers = {}
  local lsp_file = config_root .. '/lua/plugins/configs/lsp.lua'
  local content = read_file(lsp_file)

  if not content then
    return lsp_servers
  end

  -- Pattern: vim.lsp.config['servername']
  for server_name in content:gmatch([=[vim%.lsp%.config%[['"]([^'"]+)['"]%]]=]) do
    table.insert(lsp_servers, {
      name = server_name,
      source = 'plugins/configs/lsp.lua',
    })
  end

  return lsp_servers
end

-- ============================================================================
-- FORMATTER SCANNER
-- ============================================================================

-- Scan formatters from conform.lua
local function scan_all_formatters()
  local formatters = {}
  local conform_file = config_root .. '/lua/plugins/configs/conform.lua'
  local content = read_file(conform_file)

  if not content then
    return formatters
  end

  -- Pattern: filetype = { 'formatter1', 'formatter2' }
  for ft, formatter_list in content:gmatch([=[([%w_]+)%s*=%s*{%s*([^}]+)%s*}]=]) do
    for formatter in formatter_list:gmatch([=[['"]([^'"]+)['"]]=]) do
      table.insert(formatters, {
        name = formatter,
        filetype = ft,
        source = 'plugins/configs/conform.lua',
      })
    end
  end

  return formatters
end

-- ============================================================================
-- SETTINGS SCANNER
-- ============================================================================

local function scan_all_settings()
  local settings = {}
  local options_file = config_root .. '/lua/core/options.lua'
  local content = read_file(options_file)

  if not content then
    return settings
  end

  -- Pattern to match: o.setting = value -- optional comment
  for line in content:gmatch('[^\r\n]+') do
    local setting, value, comment = line:match('^%s*o%.([%w_]+)%s*=%s*([^%-]+)%s*%-%-?%s*(.*)')
    if setting and value then
      -- Clean up value (remove trailing whitespace)
      value = value:gsub('%s+$', '')
      -- Clean up comment
      comment = comment and comment:gsub('^%s+', '') or ''

      table.insert(settings, {
        name = setting,
        value = value,
        description = comment ~= '' and comment or nil,
        source = 'core/options.lua',
      })
    end
  end

  return settings
end

-- ============================================================================
-- PERSISTENT CACHE MANAGEMENT
-- ============================================================================

-- Serialize cache to Lua table string
local function serialize_cache()
  local lines = {
    '-- Auto-generated help cache file',
    '-- DO NOT EDIT MANUALLY - This file is regenerated when config files change',
    '-- Last updated: ' .. os.date('%Y-%m-%d %H:%M:%S'),
    '',
    'return {',
  }

  -- Serialize keymaps
  table.insert(lines, '  keymaps = {')
  for _, km in ipairs(cache.keymaps) do
    table.insert(
      lines,
      string.format('    { mode = %q, key = %q, desc = %q, source = %q },', km.mode, km.key, km.desc, km.source)
    )
  end
  table.insert(lines, '  },')

  -- Serialize plugins
  table.insert(lines, '  plugins = {')
  for _, p in ipairs(cache.plugins) do
    table.insert(lines, string.format('    { full_name = %q, name = %q, source = %q },', p.full_name, p.name, p.source))
  end
  table.insert(lines, '  },')

  -- Serialize LSP servers
  table.insert(lines, '  lsp_servers = {')
  for _, lsp in ipairs(cache.lsp_servers) do
    table.insert(lines, string.format('    { name = %q, source = %q },', lsp.name, lsp.source))
  end
  table.insert(lines, '  },')

  -- Serialize formatters
  table.insert(lines, '  formatters = {')
  for _, fmt in ipairs(cache.formatters) do
    table.insert(
      lines,
      string.format('    { name = %q, filetype = %q, source = %q },', fmt.name, fmt.filetype, fmt.source)
    )
  end
  table.insert(lines, '  },')

  -- Serialize modification times
  table.insert(lines, '  config_files_mtime = {')
  for filepath, mtime in pairs(cache.config_files_mtime) do
    table.insert(lines, string.format('    [%q] = %d,', filepath, mtime))
  end
  table.insert(lines, '  },')

  table.insert(lines, string.format('  last_scan_time = %d,', os.time()))
  table.insert(lines, '}')

  return table.concat(lines, '\n')
end

-- Write cache to persistent file
local function write_cache()
  local content = serialize_cache()
  local success = write_file(cache_file, content)

  if success then
    vim.notify('Help cache updated successfully', vim.log.levels.INFO)
  end

  return success
end

-- Load cache from persistent file
local function load_cache()
  local content = read_file(cache_file)

  if not content then
    return false
  end

  -- Load the cache file as a Lua chunk
  local chunk, err = loadstring(content)
  if not chunk then
    vim.notify('Failed to load cache file: ' .. tostring(err), vim.log.levels.WARN)
    return false
  end

  local loaded_cache = chunk()
  if not loaded_cache then
    return false
  end

  -- Update in-memory cache
  cache.keymaps = loaded_cache.keymaps or {}
  cache.plugins = loaded_cache.plugins or {}
  cache.lsp_servers = loaded_cache.lsp_servers or {}
  cache.formatters = loaded_cache.formatters or {}
  cache.settings = loaded_cache.settings or {}
  cache.config_files_mtime = loaded_cache.config_files_mtime or {}
  cache.last_scan_time = loaded_cache.last_scan_time

  return true
end

-- ============================================================================
-- MAIN SCAN FUNCTION
-- ============================================================================

-- Scan all config files and update cache
local function scan_all()
  vim.notify('Scanning config files...', vim.log.levels.INFO)

  cache.keymaps = scan_all_keymaps()
  cache.plugins = scan_all_plugins()
  cache.lsp_servers = scan_all_lsp_servers()
  cache.formatters = scan_all_formatters()
  cache.settings = scan_all_settings()

  update_mtimes()
  write_cache()

  vim.notify(
    string.format(
      'Scan complete: %d keymaps, %d plugins, %d LSP servers, %d formatters, %d settings',
      #cache.keymaps,
      #cache.plugins,
      #cache.lsp_servers,
      #cache.formatters,
      #cache.settings
    ),
    vim.log.levels.INFO
  )
end

-- ============================================================================
-- PUBLIC API
-- ============================================================================

-- Load help data (from cache or by scanning)
function M.load()
  if is_loaded then
    return
  end

  -- Try to load from cache first
  local cache_loaded = load_cache()

  -- If cache doesn't exist or config files modified, rescan
  if not cache_loaded or config_files_modified() then
    scan_all()
  end

  is_loaded = true
end

-- Force rescan and update cache
function M.force_rescan()
  scan_all()
  is_loaded = true
end

-- Get all keymaps
function M.get_keymaps()
  M.load()
  return cache.keymaps
end

-- Get all plugins
function M.get_plugins()
  M.load()
  return cache.plugins
end

-- Get all LSP servers
function M.get_lsp_servers()
  M.load()
  return cache.lsp_servers
end

-- Get all formatters
function M.get_formatters()
  M.load()
  return cache.formatters
end

-- Get all settings
function M.get_settings()
  M.load()
  return cache.settings
end

-- ============================================================================
-- QUERY FUNCTIONS
-- ============================================================================

-- Auto-categorize a keymap based on key pattern and description
local function auto_categorize_keymap(km)
  local key = km.key
  local desc = km.desc:lower()
  local source = km.source

  -- Category rules (in priority order)
  if key:match('^<leader>f') or desc:find('find') or desc:find('search') or source:find('telescope') then
    return 'Telescope/Find'
  elseif key:match('^<leader>g') or desc:find('git') or source:find('fugitive') then
    return 'Git'
  elseif key:match('^<leader>d') or desc:find('debug') or desc:find('breakpoint') or source:find('dap') then
    return 'Debug'
  elseif key:match('^<leader>t') or desc:find('test') or source:find('neotest') then
    return 'Testing'
  elseif key:match('^<leader>l') or desc:find('lsp') or desc:find('diagnostic') or desc:find('code action') then
    return 'LSP'
  elseif key:match('^<leader>h') or source:find('harpoon') then
    return 'Harpoon'
  elseif key:match('^<leader>y') or source:find('yanky') then
    return 'Clipboard/Yanky'
  elseif key:match('^<leader>u') or source:find('undotree') then
    return 'Undo'
  elseif key:match('^<leader>%?') or source:find('help%-system') or source:find('help%-telescope') then
    return 'Help System'
  elseif desc:find('comment') or source:find('comment') then
    return 'Comments'
  elseif desc:find('surround') or source:find('surround') then
    return 'Surround'
  elseif desc:find('buffer') or desc:find('window') or desc:find('split') then
    return 'Windows/Buffers'
  elseif source:find('keymaps') then
    return 'General'
  else
    -- Extract from source filename
    local file_category = source:match('([^/]+)%.lua$')
    return file_category or 'Other'
  end
end

-- Get keymaps by category (auto-categorized from source)
function M.get_keymaps_by_category(category)
  M.load()
  local result = {}

  for _, km in ipairs(cache.keymaps) do
    local km_category = auto_categorize_keymap(km)
    if km_category:lower():find(category:lower()) then
      table.insert(result, km)
    end
  end

  return result
end

-- Get all keymaps grouped by category
function M.get_keymaps_grouped()
  M.load()
  local grouped = {}

  for _, km in ipairs(cache.keymaps) do
    local category = auto_categorize_keymap(km)
    if not grouped[category] then
      grouped[category] = {}
    end
    table.insert(grouped[category], km)
  end

  return grouped
end

-- Get keymaps by mode
function M.get_keymaps_by_mode(mode)
  M.load()
  local result = {}

  for _, km in ipairs(cache.keymaps) do
    if km.mode == mode then
      table.insert(result, km)
    end
  end

  return result
end

-- Search keymaps by description or key
function M.search_keymaps(query)
  M.load()
  local result = {}
  local lower_query = query:lower()

  for _, km in ipairs(cache.keymaps) do
    if km.desc:lower():find(lower_query) or km.key:lower():find(lower_query) then
      table.insert(result, km)
    end
  end

  return result
end

-- Get plugins by name
function M.search_plugins(query)
  M.load()
  local result = {}
  local lower_query = query:lower()

  for _, p in ipairs(cache.plugins) do
    if p.name:lower():find(lower_query) or p.full_name:lower():find(lower_query) then
      table.insert(result, p)
    end
  end

  return result
end

-- ============================================================================
-- STATISTICS & DEBUG
-- ============================================================================

-- Get statistics
function M.get_stats()
  M.load()

  return {
    keymaps = #cache.keymaps,
    plugins = #cache.plugins,
    lsp_servers = #cache.lsp_servers,
    formatters = #cache.formatters,
    settings = #cache.settings,
    last_scan_time = cache.last_scan_time,
    cache_file = cache_file,
    cache_exists = vim.loop.fs_stat(cache_file) ~= nil,
  }
end

-- Print statistics
function M.print_stats()
  local stats = M.get_stats()

  print('=== Help Scanner Statistics ===')
  print(string.format('Keymaps: %d', stats.keymaps))
  print(string.format('Plugins: %d', stats.plugins))
  print(string.format('LSP Servers: %d', stats.lsp_servers))
  print(string.format('Formatters: %d', stats.formatters))
  print(string.format('Settings: %d', stats.settings))

  if stats.last_scan_time then
    print(string.format('Last scan: %s', os.date('%Y-%m-%d %H:%M:%S', stats.last_scan_time)))
  end

  print(string.format('Cache file: %s', stats.cache_file))
  print(string.format('Cache exists: %s', stats.cache_exists and 'Yes' or 'No'))
end

-- Clear cache file
function M.clear_cache()
  os.remove(cache_file)
  is_loaded = false
  cache = {
    keymaps = {},
    plugins = {},
    lsp_servers = {},
    formatters = {},
    settings = {},
    metadata = {},
    config_files_mtime = {},
    last_scan_time = nil,
  }
  vim.notify('Cache cleared', vim.log.levels.INFO)
end

-- ============================================================================
-- VIM HELP DOCUMENTATION GENERATOR
-- ============================================================================
-- Generates doc/nvim-config.txt for :help nvim-config command

-- Generate help documentation
function M.generate()
  local help = require('core.help-scanner')
  help.load()

  local lines = {}
  local function add(line)
    table.insert(lines, line or '')
  end

  -- Header
  add('*nvim-config.txt*  Personal Neovim Configuration Documentation')
  add('')
  add('==============================================================================')
  add('CONTENTS                                                  *nvim-config-contents*')
  add('')
  add('    1. Introduction .................... |nvim-config-intro|')
  add('    2. Keymaps ......................... |nvim-config-keymaps|')
  add('    3. Plugins ......................... |nvim-config-plugins|')
  add('    4. LSP Servers ..................... |nvim-config-lsp|')
  add('    5. Formatters ...................... |nvim-config-formatters|')
  add('    6. Settings ........................ |nvim-config-settings|')
  add('')
  add('==============================================================================')
  add('INTRODUCTION                                              *nvim-config-intro*')
  add('')
  add('This is auto-generated documentation for your personal Neovim configuration.')
  add('It is built with lazy.nvim and includes LSP, DAP, Telescope, and more.')
  add('')
  add('The help system automatically scans your config files and generates this')
  add('documentation. To regenerate, run: >lua')
  add('    require("core.help-doc-generator").generate()')
  add('<')
  add('')
  add('==============================================================================')
  add('KEYMAPS                                                  *nvim-config-keymaps*')
  add('')

  -- Group keymaps by category
  local grouped = help.get_keymaps_grouped()
  local categories = {}
  for category, _ in pairs(grouped) do
    table.insert(categories, category)
  end
  table.sort(categories)

  for _, category in ipairs(categories) do
    local keymaps = grouped[category]
    add(string.format('%s~', category))
    add('')

    for _, km in ipairs(keymaps) do
      -- Format: {lhs}  {mode}  {description}
      local mode_str = km.mode == 'n' and 'Normal'
        or km.mode == 'v' and 'Visual'
        or km.mode == 'i' and 'Insert'
        or km.mode
      add(string.format('    %-25s [%s]  %s', km.key, mode_str, km.desc))
    end
    add('')
  end

  add('==============================================================================')
  add('PLUGINS                                                  *nvim-config-plugins*')
  add('')

  local plugins = help.get_plugins()
  for _, plugin in ipairs(plugins) do
    add(string.format('    %-30s %s', plugin.name, plugin.full_name))
  end
  add('')
  add(string.format('Total: %d plugins', #plugins))
  add('')

  add('==============================================================================')
  add('LSP SERVERS                                                  *nvim-config-lsp*')
  add('')

  local lsp_servers = help.get_lsp_servers()
  for _, lsp in ipairs(lsp_servers) do
    add(string.format('    %s', lsp.name))
  end
  add('')
  add(string.format('Total: %d LSP servers', #lsp_servers))
  add('')

  add('==============================================================================')
  add('FORMATTERS                                            *nvim-config-formatters*')
  add('')

  local formatters = help.get_formatters()
  local by_filetype = {}
  for _, fmt in ipairs(formatters) do
    if not by_filetype[fmt.filetype] then
      by_filetype[fmt.filetype] = {}
    end
    table.insert(by_filetype[fmt.filetype], fmt.name)
  end

  for ft, fmts in pairs(by_filetype) do
    add(string.format('    %-15s %s', ft, table.concat(fmts, ', ')))
  end
  add('')
  add(string.format('Total: %d formatters', #formatters))
  add('')

  add('==============================================================================')
  add('SETTINGS                                              *nvim-config-settings*')
  add('')

  local settings = help.get_settings()
  for _, setting in ipairs(settings) do
    if setting.description then
      add(string.format('    %-20s = %-15s -- %s', setting.name, setting.value, setting.description))
    else
      add(string.format('    %-20s = %s', setting.name, setting.value))
    end
  end
  add('')
  add(string.format('Total: %d settings', #settings))
  add('')

  add('==============================================================================')
  add('vim:tw=78:ts=8:ft=help:norl:')

  -- Write to doc/nvim-config.txt
  local doc_dir = vim.fn.stdpath('config') .. '/doc'
  local doc_file = doc_dir .. '/nvim-config.txt'

  -- Create doc directory if it doesn't exist
  vim.fn.mkdir(doc_dir, 'p')

  -- Write file
  local file = io.open(doc_file, 'w')
  if file then
    file:write(table.concat(lines, '\n'))
    file:close()

    -- Generate helptags
    vim.cmd('helptags ' .. doc_dir)

    vim.notify('Help documentation generated: ' .. doc_file, vim.log.levels.INFO)
    return true
  else
    vim.notify('Failed to write help documentation', vim.log.levels.ERROR)
    return false
  end
end

return M
