local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

require("rust-tools").setup {
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
