local plugins = {
  { "NvChad/nvterm", enabled = false },
  { "lukas-reineke/indent-blankline.nvim", opts = { show_current_context = false } },
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
    opts = require "custom.configs.treesitter-context",
    config = function(_, opts)
      require("treesitter-context").setup(opts)
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
    "NeogitOrg/neogit",
    dependencies = { "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "nvim-telescope/telescope.nvim" },
    opts = require "custom.configs.neogit",
    cmd = "Neogit",
    config = function(_, opts)
      require("neogit").setup(opts)
    end,
  },
  {
    "numToStr/Navigator.nvim",
    lazy = false,
    config = function()
      require("Navigator").setup()
    end,
  },
  {
    "gpanders/nvim-parinfer",
    ft = require("custom.utils").lisp_ft,
  },
  {
    "windwp/nvim-autopairs",
    opts = require("custom.configs.nvim-autopairs").opts,
    config = require("custom.configs.nvim-autopairs").config,
  },
  {
    "danymat/neogen",
    cmd = "Neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    opts = require "custom.configs.neogen",
    config = true,
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    opts = {},
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "folke/trouble.nvim", "nvim-telescope/telescope.nvim" },
    lazy = false,
    opts = {},
  },
  {
    "hrsh7th/nvim-cmp",
    opts = require "custom.configs.cmp",
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    config = function()
      require "custom.configs.ufo"
    end,
    lazy = false,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = {
      extensions_list = {"file_browser"}
    }
  },
  {
    "nvim-telescope/telescope-file-browser.nvim",
    dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim", "nvim-tree/nvim-web-devicons" },
  },
}

return plugins
