local capabilities = require("plugins.configs.lspconfig").capabilities

local function on_attach(client, bufnr)
  require("plugins.configs.lspconfig").on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true
  vim.api.nvim_create_autocmd("BufWritePost", {
    callback = function()
      vim.lsp.buf.format()
    end,
  })
end

local opts = {
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = false,
      show_parameter_hints = false,
      parameter_hints_prefix = "",
      other_hints_prefix = "",
    },
  },

  server = {
    on_attach = on_attach,
    capabilities = capabilities,

    settings = {
      ["rust-analyzer"] = {
        files = {
          excludeDirs = { ".direnv" },
        },
        assist = {
          importEnforceGranularity = true,
          importPrefix = "crate",
        },
        cargo = {
          allFeatures = true,
        },
        checkOnSave = {
          -- default: `cargo check`
          command = "clippy",
        },
        inlayHints = {
          locationLinks = false,
        },
        procMacro = {
          enable = true,
        },
      },
    },
  },
}

return opts
