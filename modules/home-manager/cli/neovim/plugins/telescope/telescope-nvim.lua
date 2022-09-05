require("telescope").load_extension("fzf")
require("telescope").load_extension("coc")

require("telescope").setup {
    defaults = require("telescope.themes").get_ivy {
        mappings = {
            i ={
                ["<esc>"] = "close",
                ["<C-k>"] = "move_selection_previous",
                ["<C-j>"] = "move_selection_next",
            },
        },
    },
    extensions = {
        coc = {
            theme = 'ivy',
            prefer_locations = true, -- always use Telescope locations to preview definitions/declarations/implementations etc
        },
    },
}

vim.api.nvim_set_keymap("n", "<space>ff",
    "<cmd>lua require('telescope.builtin').find_files()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<space>fg",
    "<cmd>lua require('telescope.builtin').live_grep()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<space>fb",
    "<cmd>lua require('telescope.builtin').buffers()<cr>", { noremap = true })
vim.api.nvim_set_keymap("n", "<space>fh",
    "<cmd>lua require('telescope.builtin').help_tags()<cr>", { noremap = true })
