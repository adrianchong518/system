require("nvim-tree").setup({
    view = {
        width = 60,
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

    open_on_setup_file = true,
    update_focused_file = {
        enable = true,
    },
})

vim.api.nvim_set_keymap("n", "<space>te", ":lua require'nvim-tree'.toggle(false, true)<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>tE", ":NvimTreeFocus<CR>", { noremap = true, silent = true })
