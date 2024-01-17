local M = {}

M.setup = function()
  local config = require("user").config

  lvim.plugins = {
    -- {
    --   "folke/trouble.nvim",
    --   cmd = "TroubleToggle",
    -- },
    {
      "christoomey/vim-tmux-navigator",
      lazy = false,
    },
    {
      "b0o/incline.nvim",
      config = function()
        require("user.plugins.incline").setup()
      end,
    },
    {
      "j-hui/fidget.nvim",
      commit = "0ba1e16",
      pin = true,
      config = function()
        require("user.plugins.fidget").setup()
      end,
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
    },
    {
      "folke/zen-mode.nvim",
      config = function()
        require("zen-mode").setup {}
      end,
    },
    {
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("user.plugins.crates").setup()
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
        require("user.plugins.zk").setup()
      end,
    },
    {
      "kylechui/nvim-surround",
      version = "*", -- Use for stability; omit to use `main` branch for the latest features
      event = "VeryLazy",
      config = function()
        require("nvim-surround").setup {
          -- Configuration here, or leave empty to use defaults
        }
      end,
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        lvim.colorscheme = "catppuccin"
      end,
    },
    {
      "hood/popui.nvim",
      config = function()
        vim.ui.select = require "popui.ui-overrider"
        vim.ui.input = require "popui.input-overrider"
      end,
    },
  }

  _ = lvim.builtin.bufferline.active and require("user.plugins.bufferline").setup()
  _ = lvim.builtin.lualine.active and require("user.plugins.lualine").setup()

  require("user.plugins.telescope").setup()
  require("user.plugins.treesitter").setup()
  require("user.plugins.nvimtree").setup()
  require("user.plugins.indent_blankline").setup()
end

return M
