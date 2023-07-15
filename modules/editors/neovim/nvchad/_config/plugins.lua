local plugins = {
  {
    "neovim/nvim-lspconfig",

    dependencies = {
      "jose-elias-alvarez/null-ls.nvim",
      config = function()
        require "custom.configs.null-ls"
      end,
    },

    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "williamboman/mason.nvim",
    enabled = false,
  },
  {
    "christoomey/vim-tmux-navigator",
    lazy = false,
  },
  {
    "b0o/incline.nvim",
    lazy = false,
    config = function()
      require "custom.configs.incline"
    end,
  },
  {
    "saecki/crates.nvim",
    event = { "BufRead Cargo.toml" },
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require "custom.configs.crates"
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    config = function()
      require("user.plugins.rust_tools").setup()
    end,
    ft = { "rust", "rs" },
  },
  {
    "mickael-menu/zk-nvim",
    config = function()
      require "custom.configs.zk"
    end,
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
  },
}

return plugins
