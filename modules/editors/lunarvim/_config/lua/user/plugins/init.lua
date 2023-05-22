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
      enabled = config.winbar_provider == "filename",
    },
    {
      "j-hui/fidget.nvim",
      config = function()
        require("user.plugins.fidget").setup()
      end,
      enabled = config.enabled_plugins.fidget,
    },
    {
      "nvim-telescope/telescope-file-browser.nvim",
      dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
      enabled = config.enabled_plugins.telescope.file_browser,
    },
    {
      "folke/zen-mode.nvim",
      config = function()
        require("zen-mode").setup {}
      end,
      enabled = config.enabled_plugins.zen_mode,
    },
    {
      "saecki/crates.nvim",
      event = { "BufRead Cargo.toml" },
      dependencies = { "nvim-lua/plenary.nvim" },
      config = function()
        require("user.plugins.crates").setup()
      end,
      enabled = config.enabled_plugins.crates,
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
      enabled = config.enabled_plugins.zk,
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
      enabled = config.enabled_plugins.surround,
    },
    {
      "catppuccin/nvim",
      name = "catppuccin",
      config = function()
        lvim.colorscheme = "catppuccin"
      end,
    },
  }

  _ = lvim.builtin.bufferline.active and require("user.plugins.bufferline").setup()
  _ = lvim.builtin.lualine.active and require("user.plugins.lualine").setup()

  require("user.plugins.telescope").setup()
  require("user.plugins.treesitter").setup()
  require("user.plugins.nvimtree").setup()
end

return M
