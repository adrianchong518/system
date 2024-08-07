require("todo-comments").setup()

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "[todo comments] next" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "[todo comments] prev" })

require("which-key").add {
  { "<leader>ft", "<CMD>TodoTelescope<CR>", desc = "[todo comments] open in telescope" },
}
