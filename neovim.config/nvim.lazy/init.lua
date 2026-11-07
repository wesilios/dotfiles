--Validation check for neovim version. Required >= v0.12.0
if vim.fn.has('nvim-0.12.0') ~= 1 then
  vim.api.nvim_err_writeln('Neovim v0.12.0 or higher is required for this configuration.')
  return
end

--Load core settings
require('core.autocmds')
require('core.keymaps')
require('core.options')
require('core.filetype-settings').setup()

-- Load plugins
require('plugins')
