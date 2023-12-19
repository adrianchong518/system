local M = {}

M.capabilities = (function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return capabilities
end)()

M.on_attach_builder = function(opts)
  return function(client, bufnr)
    require("plugins.configs.lspconfig").on_attach(client, bufnr)

    if opts.auto_format then
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentRangeFormattingProvider = true
      vim.api.nvim_create_autocmd("BufWritePost", {
        buffer = 0,
        callback = function()
          vim.lsp.buf.format()
        end,
      })
    end
  end
end

M.setup = function()
  local lspconfig = require "lspconfig"
  local servers = {
    -- { name = "ccls", auto_format = true },
    {name = "clangd", auto_format = true},
    { name = "zls", auto_format = true },
    { name = "racket_langserver", auto_format = true },
    {
      name = "pylsp",
      auto_format = true,
      settings = {
        ["pylsp"] = {
          configurationSources = { "flake8" },
          plugins = {
            autopep8 = { enabled = false },
            flake8 = { enabled = true },
          },
        },
      },
    },
    {
      name = "nil_ls",
      auto_format = true,
      settings = {
        ["nil"] = {
          formatting = { command = { "nixpkgs-fmt" } },
        },
      },
    },
  }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp.name].setup {
      on_attach = M.on_attach_builder(lsp),
      capabilities = M.capabilities,
      settings = lsp.settings,
    }
  end
end

return M
