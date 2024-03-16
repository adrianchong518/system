local navic = require "nvim-navic"
navic.setup()

---Indicators for special modes,
---@return string status
local function extra_mode_status()
  -- recording macros
  local reg_recording = vim.fn.reg_recording()
  if reg_recording ~= "" then
    return " @" .. reg_recording
  end
  -- executing macros
  local reg_executing = vim.fn.reg_executing()
  if reg_executing ~= "" then
    return " @" .. reg_executing
  end
  -- ix mode (<C-x> in insert mode to trigger different builtin completion sources)
  local mode = vim.api.nvim_get_mode().mode
  if mode == "ix" then
    return "^X: (^]^D^E^F^I^K^L^N^O^Ps^U^V^Y)"
  end
  return ""
end

local function cwd()
  return "󰉋  " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
end

require("lualine").setup {
  globalstatus = true,

  sections = {
    lualine_b = { "diff", "diagnostics" },
    lualine_c = {
      -- nvim-navic
      { navic.get_location, cond = navic.is_available },
    },
    lualine_y = { "searchcount", "progress", "location" },
    lualine_z = {
      -- (see above)
      { extra_mode_status },
    },
  },

  inactive_sections = {
    lualine_c = {},
  },

  options = {
    theme = "auto",
    section_separators = '',
    component_separators = '|',
  },

  tabline = {
    lualine_a = {
      { "tabs", mode = 1, show_modified_status = false },
    },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = { "branch" },
    lualine_z = { cwd },
  },

  winbar = {
    lualine_z = {
      { "filename", path = 1, file_status = true, newfile_status = true },
    },
  },

  inactive_winbar = {
    lualine_z = {
      { "filename", path = 1, file_status = true, newfile_status = true },
    },
  },

  extensions = { "fugitive", "fzf", "toggleterm", "quickfix" },
}
