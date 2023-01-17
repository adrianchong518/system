require("trouble").setup({
    use_diagnostic_signs = false,
})

vim.keymap.set("n", "<space>xx", "<cmd>TroubleToggle<cr>", { silent = true })
vim.keymap.set("n", "<space>xD", "<cmd>TroubleToggle workspace_diagnostics<cr>", { silent = true })
vim.keymap.set("n", "<space>xd", "<cmd>TroubleToggle document_diagnostics<cr>", { silent = true })
vim.keymap.set("n", "<space>xl", "<cmd>TroubleToggle loclist<cr>", { silent = true })
vim.keymap.set("n", "<space>xq", "<cmd>TroubleToggle quickfix<cr>", { silent = true })
vim.keymap.set("n", "gR", "<cmd>TroubleToggle lsp_references<cr>", { silent = true })

vim.keymap.set("n", "[x", function() require("trouble").previous({skip_groups = true, jump = true}) end)
vim.keymap.set("n", "]x", function() require("trouble").next({skip_groups = true, jump = true}) end)
