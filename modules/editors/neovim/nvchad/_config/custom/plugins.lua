local plugins = {
  { "NvChad/nvterm", enabled = false },
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
      require("custom.configs.lspconfig").setup()
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = "" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      auto_install = true,
      ensure_installed = { "markdown", "markdown_inline", "regex" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    dependencies = "nvim-treesitter/nvim-treesitter",
    lazy = false,
    config = function()
      require("treesitter-context").setup()
    end,
  },
  {
    "b0o/incline.nvim",
    lazy = false,
    opts = require "custom.configs.incline",
    config = function(_, opts)
      require("incline").setup(opts)
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
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = require "custom.configs.rust-tools",
    config = function(_, opts)
      require("rust-tools").setup(opts)
    end,
  },
  {
    "mickael-menu/zk-nvim",
    ft = "markdown",
    dependencies = "neovim/nvim-lspconfig",
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
  {
    "numToStr/Navigator.nvim",
    lazy = false,
    config = function()
      require("Navigator").setup()
    end,
  },
}

return plugins
