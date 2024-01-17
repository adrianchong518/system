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
    on_attach = require("custom.configs.lspconfig").on_attach_builder { auto_format = true },
    capabilities = require("custom.configs.lspconfig").capabilities,

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
