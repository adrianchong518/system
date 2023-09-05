local M = {}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

M.ui = {
  theme = "catppuccin",
  tabufline = {
    enabled = false,
  },
  nvdash = {
    load_on_startup = true,
    buttons = {
      { "  Find File", "Spc f f", "Telescope find_files" },
      { "󰈚  Recent Files", "Spc f o", "Telescope oldfiles" },
      { "󰈭  Find Word", "Spc f w", "Telescope live_grep" },
      { "  Bookmarks", "Spc f m", "Telescope marks" },
      { "  Mappings", "Spc h c", "NvCheatsheet" },
    },
  },
  hl_add = require "custom.ui.hl_add",
}

return M
