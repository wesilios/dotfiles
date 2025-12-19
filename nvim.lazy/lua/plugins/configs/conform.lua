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
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      yaml = { 'prettier' },
      markdown = { 'prettier' },
      -- C# formatting is handled by Roslyn LSP
      -- go = { "gofmt" },
      -- python = { "black" },
      -- c = { "clang-format" },
      -- cpp = { "clang-format" },
    },

    -- Formatter-specific settings
    formatters = {
      -- Prettier configuration (for JS, TS, CSS, HTML, etc.)
      prettier = {
        prepend_args = {
          '--print-width',
          '120',
          '--tab-width',
          '2',
          '--use-tabs',
          'false',
          '--single-quote',
          'true',
          '--trailing-comma',
          'es5',
          '--prose-wrap',
          'always',
        },
      },
      -- stylua is configured via stylua.toml file
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
