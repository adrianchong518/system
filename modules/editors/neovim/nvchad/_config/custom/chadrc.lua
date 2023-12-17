local M = {}

M.plugins = "custom.plugins"
M.mappings = require "custom.mappings"

M.ui = {
  theme = "catppuccin",
  tabufline = {
    enabled = false,
  },
  statusline = {
    theme = "default",
    separator_style = "block",
    overriden_modules = function(modules)
      -- file info
      modules[2] = (function()
        local icon = " 󰈚 "
        local path = vim.api.nvim_buf_get_name(0)
        local name = (path == "" and "Empty ") or require("plenary.path").new(path):make_relative()

        if name ~= "Empty " then
          local devicons_present, devicons = pcall(require, "nvim-web-devicons")

          if devicons_present then
            local ft_icon = devicons.get_icon(name)
            icon = (ft_icon ~= nil and " " .. ft_icon) or icon
          end

          name = " " .. name .. " "
        end

        return "%#St_file_info#" .. icon .. name .. "%#St_file_sep#█"
      end)()

      -- cwd
      modules[9] = (function()
        local dir_icon = "%#St_cwd_icon#" .. "󰉋 "
        local dir_name = "%#St_cwd_text#" .. " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~") .. " "
        return (vim.o.columns > 85 and ("%#St_cwd_sep#█" .. dir_icon .. dir_name)) or ""
      end)()

      -- line column
      table.insert(modules, "%l:%c")
    end,
  },
  nvdash = {
    load_on_startup = false,
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
