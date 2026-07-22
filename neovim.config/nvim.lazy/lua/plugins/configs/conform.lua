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
      yaml = { 'yamlfmt' },
      yml = { 'yamlfmt' },
      markdown = { 'prettier_md' },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
      cmake = { 'cmake_format' },
      -- dockerfile = { 'hadolint' },
      -- dotenv files - use basic formatters
      ['env'] = { 'trim_whitespace', 'trim_newlines' },
      -- C# formatting is handled by Roslyn LSP
      -- go = { "gofmt" },
      -- python = { "black" },
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
      prettier_md = {
        inherit = true,
        prepend_args = {
          '--prose-wrap',
          'preserve',
        },
      },
      -- clang-format configuration (for C/C++)
      ['clang-format'] = {
        prepend_args = {
          '--style={BasedOnStyle: LLVM, IndentWidth: 4, ColumnLimit: 120, UseTab: Never}',
        },
      },
      -- cmake-format configuration (for CMake files)
      cmake_format = {
        prepend_args = {
          '--line-width',
          '120',
          '--tab-size',
          '4',
        },
      },
      -- yamlfmt configuration (for YAML files)
      yamlfmt = {
        prepend_args = {
          '-formatter',
          'indent=2,max_line_length=120,retain_line_breaks=true',
        },
      },
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
