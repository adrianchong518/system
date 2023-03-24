local M = {}

M.setup = function()
  local config = require("user").config

  lvim.plugins = {
    -- {
    --   "folke/trouble.nvim",
    --   cmd = "TroubleToggle",
    -- },
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
  }

  _ = lvim.builtin.bufferline.active and require("user.plugins.bufferline").setup()
  _ = lvim.builtin.lualine.active and require("user.plugins.lualine").setup()

  require("user.plugins.telescope").setup()
  require("user.plugins.treesitter").setup()
  require("user.plugins.nvimtree").setup()
end

return M
