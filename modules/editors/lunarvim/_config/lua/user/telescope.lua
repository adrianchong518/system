local M = {}

M.config = function()
  lvim.builtin.telescope.defaults = {
    layout_strategy = "flex",
    layout_config = {
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
    },
    sorting_strategy = "ascending",
    dynamic_preview_title = true,
    path_display = {},
  }

  lvim.builtin.telescope.pickers.buffers.initial_mode = "insert"
end

return M
