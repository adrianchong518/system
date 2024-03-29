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

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {
    on_attach = on_attach,

    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
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
