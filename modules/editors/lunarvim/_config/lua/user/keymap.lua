local M = {}

local config = require("user").config

M.setup = function()
  lvim.leader = "space"

  lvim.keys.normal_mode["<C-h>"] = "<cmd> TmuxNavigateLeft<CR>"
  lvim.keys.normal_mode["<C-l>"] = "<cmd> TmuxNavigateRight<CR>"
  lvim.keys.normal_mode["<C-j>"] = "<cmd> TmuxNavigateDown<CR>"
  lvim.keys.normal_mode["<C-k>"] = "<cmd> TmuxNavigateUp<CR>"

  lvim.builtin.which_key.mappings["/"] = nil
  lvim.builtin.which_key.mappings.w = nil
  lvim.builtin.which_key.mappings.q = nil
  lvim.builtin.which_key.mappings.c = nil

  if config.enabled_plugins.telescope.file_browser then
    lvim.builtin.which_key.mappings.E =
      { require("telescope").extensions.file_browser.file_browser, "Telecope Explorer" }
  end

  lvim.builtin.which_key.mappings.s = nil
  lvim.builtin.which_key.mappings.f = {
    name = "Find",
    b = { require("telescope.builtin").builtin, "Builtin" },
    f = { require("lvim.core.telescope.custom-finders").find_project_files, "Project File" },
    F = { require("telescope.builtin").find_files, "All Files" },
    t = { require("user.plugins.telescope").text_curbuf, "Text in Current Buffer" },
    g = { require("telescope.builtin").live_grep, "Live Grep" },
    l = { require("telescope.builtin").resume, "Last Search" },
    s = { require("telescope.builtin").git_status, "Git Status" },
  }

  lvim.builtin.which_key.mappings.b = {
    name = "Buffers",
    f = { require("telescope.builtin").find_buffers, "Find" },
    q = { "<cmd>BufferKill<cr>", "Close" },
  }

  lvim.builtin.which_key.mappings.h = {
    name = "Help",
    h = { require("telescope.builtin").help_tags, "Help" },
    k = { require("telescope.builtin").keymaps, "Keymap" },
    m = { require("telescope.builtin").man_pages, "Man pages" },
    t = { require("telescope.builtin").colorscheme, "Theme" },
  }

  if config.enabled_plugins.zen_mode then
    lvim.builtin.which_key.mappings.z = {
      name = "Zen",
      z = { require("zen-mode").toggle, "Zen Mode" },
    }
  end

  if config.enabled_plugins.zk then
    lvim.builtin.which_key.mappings.n = {
      name = "Notes",
      n = { "<cmd>ZkNew { title = vim.fn.input('Title: ') }<cr>", "New Note" },
      o = { "<cmd>ZkNotes { sort = { 'modified' } }<cr>", "Open Note" },
      t = { "<cmd>ZkTags<cr>", "Open Note with Tag" },
      f = { "<cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<cr>", "Search Notes" },
    }

    require("which-key").register({
      ["<leader>nf"] = { ":'<,'>ZkMatch<cr>", "Search selection in Notes" },
    }, { mode = "v" })
  end
end

return M
