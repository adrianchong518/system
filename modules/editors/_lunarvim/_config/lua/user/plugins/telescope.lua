local M = {}

local config = require("user").config

local builtin = require "telescope.builtin"
local themes = require "telescope.themes"

M.setup = function()
  lvim.builtin.telescope.defaults.layout_strategy = "flex"
  lvim.builtin.telescope.defaults.layout_config = {
    width = { 0.8, max = 235 },
    height = { 0.90, max = 50 },
    prompt_position = "top",
    preview_cutoff = 75,
    flex = {
      flip_columns = 185,
    },
    vertical = {
      preview_height = 15,
    },
  }
  lvim.builtin.telescope.defaults.sorting_strategy = "ascending"
  lvim.builtin.telescope.defaults.dynamic_preview_title = true
  lvim.builtin.telescope.defaults.path_display = {}

  lvim.builtin.telescope.pickers.buffers.initial_mode = "insert"

  lvim.builtin.telescope.on_config_done = function(telescope)
    _ = pcall(telescope.load_extension, "file_browser")
  end
end

M.text_curbuf = function()
  local opts = themes.get_dropdown {
    previewer = false,
    shorten_path = false,
    layout_config = {
      width = { 0.45, min = 100 },
      prompt_position = "top",
    },
  }

  builtin.current_buffer_fuzzy_find(opts)
end

return M
