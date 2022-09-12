require("todo-comments").setup()

-- NOTE: Filtering by keywords seems broken
vim.keymap.set("n", "<space>ft", ":TodoTelescope<cr>")
