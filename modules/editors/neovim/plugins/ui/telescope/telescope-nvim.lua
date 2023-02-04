require("telescope").setup({
    defaults = {
        layout_strategy = "flex",
        layout_config = {
            width = { 0.8, max = 235 },
            height = { 0.90, max = 50 },
            prompt_position = "top",
            flex = {
                flip_columns = 185,
            },
            vertical = {
                preview_height = 15,
            },
        },
        sorting_strategy = "ascending",
        dynamic_preview_title = true,

        mappings = {
            i = {
                ["<C-k>"] = "move_selection_previous",
                ["<C-j>"] = "move_selection_next",
                ["<c-t>"] = require("trouble.providers.telescope").open_with_trouble,
            },
            n = {
                ["<c-t>"] = require("trouble.providers.telescope").open_with_trouble,
            },
        },
    },
    extensions = {
        fzf = {
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        file_browser = {
            grouped = true,
            hijack_netrw = true,
        },
    },
})

require("telescope").load_extension("fzf")
require("telescope").load_extension("file_browser")

-- Find
vim.keymap.set("n", "<space>ff", require("telescope.builtin").find_files)
vim.keymap.set("n", "<space>fg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<space>fb", require("telescope").extensions.file_browser.file_browser)
vim.keymap.set("n", "<space>fh", require("telescope.builtin").help_tags)

-- Buffer
vim.keymap.set("n", "<space>bb", require("telescope.builtin").buffers)
