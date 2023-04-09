local M = {}

M.setup = function()
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
      on_attach = require("lvim.lsp").common_on_attach,
      on_init = require("lvim.lsp").common_on_init,

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
end

return M
