-- Get completion capabilities from nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
local has_cmp, cmp_nvim_lsp = pcall(require, 'cmp_nvim_lsp')
if has_cmp then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

require('roslyn').setup({
  config = {
    capabilities = capabilities,
    -- Settings to pass to the Roslyn language server
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
    on_attach = function(client, bufnr)
      -- Disable inlay hints by default
      vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })

      -- Note: <leader>th keymap is set in lsp.lua for all LSP servers

      -- Show inlay hints when cursor holds on a variable
      local hint_augroup = vim.api.nvim_create_augroup('InlayHintOnHold', { clear = false })

      -- Clear previous autocmds for this buffer
      vim.api.nvim_clear_autocmds({ group = hint_augroup, buffer = bufnr })

      -- Show hints on cursor hold (when you stop moving cursor)
      vim.api.nvim_create_autocmd('CursorHold', {
        group = hint_augroup,
        buffer = bufnr,
        callback = function()
          -- Only show if hints are globally disabled
          if not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }) then
            -- Temporarily enable hints for current line context
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

            -- Disable after a short delay
            vim.defer_fn(function()
              if vim.api.nvim_buf_is_valid(bufnr) then
                vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
              end
            end, 2000) -- Show for 2 seconds
          end
        end,
      })
    end,
  },
})

