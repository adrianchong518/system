require("nvim-tree").setup {
  view = {
    width = 50,
  },

  renderer = {
    add_trailing = true,
    group_empty = true,
    highlight_git = true,
    indent_markers = {
      enable = true,
    },
    icons = {
      git_placement = "signcolumn",
    },
  },

  update_focused_file = {
    enable = true,
  },
}

vim.keymap.set("n", "<space>te", function()
  require("nvim-tree").toggle(false, true)
end, { silent = true })
vim.keymap.set("n", "<space>tE", ":NvimTreeFocus<cr>", { silent = true })
