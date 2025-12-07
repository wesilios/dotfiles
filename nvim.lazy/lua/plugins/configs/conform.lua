local M = {}

function M.options()
  options = {
    formatters_by_ft = {
      lua = { 'stylua' },
      css = { 'prettier' },
      html = { 'prettier' },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      json = { 'prettier' },
      tsx = { 'prettier' },
      -- go = { "gofmt" },
      -- python = { "black" },
    },
    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 2500,
      lsp_format = 'fallback',
    },
  }

  return options
end

function M.config()
  vim.keymap.set({ 'n', 'v' }, '<leader>cf', function()
    require('conform').format({ async = true, lsp_fallback = true })
  end, { desc = 'Format buffer with Conform' })
end

return M
