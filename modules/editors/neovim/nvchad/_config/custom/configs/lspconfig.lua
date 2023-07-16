local M = {}

M.capabilities = require("plugins.configs.lspconfig").capabilities

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
    { name = "ccls", auto_format = true },
    { name = "zls", auto_format = true },
  }

  for _, lsp in ipairs(servers) do
    lspconfig[lsp.name].setup {
      on_attach = M.on_attach_builder(lsp),
      capabilities = M.capabilities,
    }
  end

  lspconfig["nil_ls"].setup {
    on_attach = M.on_attach_builder { auto_format = true },
    capabilities = M.capabilities,
    settings = {
      ["nil"] = {
        formatting = { command = { "nixpkgs-fmt" } },
      },
    },
  }
end

return M
