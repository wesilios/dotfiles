local mason_root = require('mason.settings').current.install_root_dir

vim.lsp.config('roslyn', {
  on_attach = function()
    print('This will run when the server attaches!')
  end,
  settings = {
    ['csharp|inlay_hints'] = {
      csharp_enable_inlay_hints_for_implicit_object_creation = true,
      csharp_enable_inlay_hints_for_implicit_variable_types = true,
    },
    ['csharp|code_lens'] = {
      dotnet_enable_references_code_lens = true,
    },
  },
})

-- Command and arguments to start the server.
vim.lsp.config['luals'] = {
  cmd = { 'lua-language-server' },

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
    },
  },
}

-- Clangd LSP configuration for C/C++
vim.lsp.config['clangd'] = {
  cmd = { 'clangd' },

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
