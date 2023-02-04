require("todo-comments").setup()

-- NOTE: Filtering by keywords seems broken
vim.keymap.set("n", "<space>ft", "<cmd>TodoTelescope<cr>")
vim.keymap.set("n", "<space>fT", "<cmd>TodoTrouble<cr>")
