local M = {}

local config = require("user").config

M.setup = function()
  lvim.leader = "space"

  lvim.builtin.which_key.mappings["/"] = nil
  lvim.builtin.which_key.mappings["w"] = nil
  lvim.builtin.which_key.mappings["q"] = nil
  lvim.builtin.which_key.mappings["c"] = nil

  lvim.builtin.which_key.mappings["f"] =
    { require("lvim.core.telescope.custom-finders").find_project_files, " Find File" }

  if config.enabled_plugins.telescope.file_browser then
    lvim.builtin.which_key.mappings["E"] =
      { require("telescope").extensions.file_browser.file_browser, "Telecope Explorer" }
  end

  lvim.builtin.which_key.mappings["s"] = nil
  lvim.builtin.which_key.mappings["F"] = {
    name = "Find",
    b = { require("telescope.builtin").builtin, "Builtin" },
    f = { require("telescope.builtin").find_files, "Files" },
    t = { require("user.plugins.telescope").text_curbuf, "Text in Current Buffer" },
    g = { require("telescope.builtin").live_grep, "Live Grep" },
    l = { require("telescope.builtin").resume, "Last Search" },
    s = { require("telescope.builtin").git_status, "Git Status" },
  }

  lvim.builtin.which_key.mappings["b"] = {
    name = "Buffers",
    f = { require("telescope.builtin").find_buffers, "Find" },
    q = { "<cmd>BufferKill<cr>", "Close" },
  }

  lvim.builtin.which_key.mappings["h"] = {
    name = "Help",
    h = { require("telescope.builtin").help_tags, "Help" },
    k = { require("telescope.builtin").keymaps, "Keymap" },
    m = { require("telescope.builtin").man_pages, "Man pages" },
    t = { require("telescope.builtin").colorscheme, "Theme" },
  }
end

return M
