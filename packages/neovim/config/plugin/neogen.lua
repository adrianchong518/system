require('neogen').setup()

vim.keymap.set("n", "<leader>lg", require('neogen').generate, {desc = "[neogen] generate annotation"})
