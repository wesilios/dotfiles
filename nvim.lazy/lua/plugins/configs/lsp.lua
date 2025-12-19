local mason_root = require('mason.settings').current.install_root_dir

-- Setup completion capabilities for LSP
local capabilities = vim.lsp.protocol.make_client_capabilities()
-- Add nvim-cmp capabilities if available
local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

-- LSP Keymaps setup function (called on LspAttach)
local function setup_lsp_keymaps(bufnr)
  local map = vim.keymap.set
  local opts = { buffer = bufnr, silent = true }

  -- Go to definition
  map('n', 'gd', vim.lsp.buf.definition, vim.tbl_extend('force', opts, { desc = 'LSP: Go to definition' }))

  -- Go to declaration
  map('n', 'gD', vim.lsp.buf.declaration, vim.tbl_extend('force', opts, { desc = 'LSP: Go to declaration' }))

  -- Hover documentation
  map('n', 'K', vim.lsp.buf.hover, vim.tbl_extend('force', opts, { desc = 'LSP: Hover documentation' }))

  -- Go to implementation
  map('n', 'gi', vim.lsp.buf.implementation, vim.tbl_extend('force', opts, { desc = 'LSP: Go to implementation' }))

  -- Signature help
  map('n', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'LSP: Signature help' }))
  map('i', '<C-k>', vim.lsp.buf.signature_help, vim.tbl_extend('force', opts, { desc = 'LSP: Signature help' }))

  -- Rename symbol
  map('n', '<leader>rn', vim.lsp.buf.rename, vim.tbl_extend('force', opts, { desc = 'LSP: Rename symbol' }))

  -- Code action (includes auto-import)
  map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, vim.tbl_extend('force', opts, { desc = 'LSP: Code action' }))

  -- Go to references
  map('n', 'gr', vim.lsp.buf.references, vim.tbl_extend('force', opts, { desc = 'LSP: Go to references' }))

  -- Format buffer
  map('n', '<leader>lf', function()
    vim.lsp.buf.format({ async = true })
  end, vim.tbl_extend('force', opts, { desc = 'LSP: Format buffer' }))

  -- Show diagnostics in floating window
  map('n', '<leader>e', vim.diagnostic.open_float, vim.tbl_extend('force', opts, { desc = 'LSP: Show diagnostics' }))

  -- Go to previous/next diagnostic
  map('n', '[d', vim.diagnostic.goto_prev, vim.tbl_extend('force', opts, { desc = 'LSP: Previous diagnostic' }))
  map('n', ']d', vim.diagnostic.goto_next, vim.tbl_extend('force', opts, { desc = 'LSP: Next diagnostic' }))

  -- Show all diagnostics in location list
  map(
    'n',
    '<leader>dl',
    vim.diagnostic.setloclist,
    vim.tbl_extend('force', opts, { desc = 'LSP: Diagnostics to loclist' })
  )

  -- Type definition
  map('n', '<leader>D', vim.lsp.buf.type_definition, vim.tbl_extend('force', opts, { desc = 'LSP: Type definition' }))

  -- Workspace symbols
  map(
    'n',
    '<leader>ws',
    vim.lsp.buf.workspace_symbol,
    vim.tbl_extend('force', opts, { desc = 'LSP: Workspace symbols' })
  )

  -- Toggle inlay hints (if supported by LSP)
  map('n', '<leader>th', function()
    local current = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
    vim.lsp.inlay_hint.enable(not current, { bufnr = bufnr })
    if not current then
      vim.notify('Inlay hints enabled', vim.log.levels.INFO)
    else
      vim.notify('Inlay hints disabled', vim.log.levels.INFO)
    end
  end, vim.tbl_extend('force', opts, { desc = 'LSP: Toggle inlay hints' }))
end

-- Roslyn LSP configuration for C#
-- Note: roslyn.nvim plugin handles the actual server setup
-- This config is for the built-in LSP client settings
vim.lsp.config('roslyn', {
  capabilities = capabilities,
  -- Roslyn-specific settings for inlay hints and code lens
  settings = {
    ['csharp|inlay_hints'] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
      csharp_enable_inlay_hints_for_lambda_parameter_types = true,
      csharp_enable_inlay_hints_for_types = true,
      dotnet_enable_inlay_hints_for_indexer_parameters = true,
      dotnet_enable_inlay_hints_for_literal_parameters = true,
      dotnet_enable_inlay_hints_for_object_creation_parameters = true,
      dotnet_enable_inlay_hints_for_other_parameters = true,
      dotnet_enable_inlay_hints_for_parameters = true,
      dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
      dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
    },
    ['csharp|code_lens'] = {
      dotnet_enable_references_code_lens = true,
      dotnet_enable_tests_code_lens = true,
    },
    ['csharp|completion'] = {
      dotnet_provide_regex_completions = true,
      dotnet_show_completion_items_from_unimported_namespaces = true,
      dotnet_show_name_completion_suggestions = true,
    },
  },
})

-- Command and arguments to start the server.
vim.lsp.config['luals'] = {
  cmd = { 'lua-language-server' },
  capabilities = capabilities,

  -- Filetypes to automatically attach to.
  filetypes = { 'lua' },

  -- Sets the "root directory" to the parent directory of the file in the
  -- current buffer that contains either a ".luarc.json" or a
  -- ".luarc.jsonc" file. Files that share a root directory will reuse
  -- the connection to the same LSP server.
  -- Nested lists indicate equal priority, see |vim.lsp.Config|.
  root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },

  -- Specific settings to send to the server. The schema for this is
  -- defined by the server. For example the schema for lua-language-server
  -- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file('', true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

-- Clangd LSP configuration for C/C++
vim.lsp.config['clangd'] = {
  cmd = { 'clangd' },
  capabilities = capabilities,

  -- Filetypes to automatically attach to.
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda', 'proto' },

  -- Root directory markers for C/C++ projects
  root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },

  -- Clangd-specific settings
  settings = {
    clangd = {
      -- Enable all clangd features
      fallbackFlags = {},
    },
  },
}

-- LspAttach autocmd to set up keymaps when LSP attaches to buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true }),
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    -- Set up keymaps for all LSP clients
    setup_lsp_keymaps(bufnr)

    -- Enable inlay hints if supported (except for roslyn - it has custom config)
    if client and client.server_capabilities.inlayHintProvider then
      -- Roslyn handles inlay hints in its own on_attach (disabled by default)
      if client.name ~= 'roslyn' then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
      end
    end

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    print(string.format('LSP attached: %s', client and client.name or 'unknown'))
  end,
})
