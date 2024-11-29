require("todo-comments").setup {
  keywords = {
    TODO = { alt = { "todo", "unimplemented", "missingfigure" } },
  },
  highlight = {
    pattern = {
      [[.*<(KEYWORDS)\s*:]],
      [[.*<(KEYWORDS)\s*!\(]],
      [[.*\\<(KEYWORDS)\s*]],
    },
    comments_only = false,
  },
  search = {
    pattern = [[\b\\?(KEYWORDS)(:|!\(|\[|\{)]],
  },
}

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "[todo comments] next" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "[todo comments] prev" })

require("which-key").add {
  { "<leader>ft", "<CMD>TodoTelescope<CR>", desc = "[todo comments] open in telescope" },
}
