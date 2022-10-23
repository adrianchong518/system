require('telescope').setup({
    defaults = {
        layout_strategy = 'flex',
        layout_config = {
            width = { 0.8, max = 235 },
            height = { 0.90, max = 50 },
            prompt_position = 'top',
            flex = {
                flip_columns = 185,
            },
            vertical = {
                preview_height = 15,
            },
        },
        sorting_strategy = 'ascending',
        dynamic_preview_title = true,

        mappings = {
            i = {
                ['<esc>'] = 'close',
                ['<C-k>'] = 'move_selection_previous',
                ['<C-j>'] = 'move_selection_next',
            },
        },
    },
    extensions = {
        coc = {
            prefer_locations = true,
        },
        fzf = {
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case',
        },
        file_browser = {
            grouped = true,
            hijack_netrw = true,
        },
    },
})

require('telescope').load_extension('fzf')
require('telescope').load_extension('coc')
require('telescope').load_extension('file_browser')

-- coc
vim.keymap.set('n', 'gd', ':Telescope coc definitions<cr>', { silent = true})
vim.keymap.set('n', 'gy', ':Telescope coc type-definitions<cr>', { silent = true})
vim.keymap.set('n', 'gi', ':Telescope coc implementations<cr>', { silent = true})
vim.keymap.set('n', 'gr', ':Telescope coc references<cr>', { silent = true})

vim.keymap.set('n', '<space>cd', ':Telescope coc diagnostics<cr>', { silent = true, nowait = true })
vim.keymap.set('n', '<space>cD', ':Telescope coc workspace_diagnostics<cr>', { silent = true, nowait = true })
vim.keymap.set('n', '<space>co', ':Telescope coc document_symbols<cr>', { silent = true, nowait = true })
vim.keymap.set('n', '<space>cs', ':Telescope coc workspace_symbols<cr>', { silent = true, nowait = true })
vim.keymap.set('n', '<space>cc', ':Telescope coc commands<cr>', { silent = true, nowait = true })

-- Find
vim.keymap.set('n', '<space>ff', function() require('telescope.builtin').find_files() end)
vim.keymap.set('n', '<space>fg', function() require('telescope.builtin').live_grep() end)
vim.keymap.set('n', '<space>fb', function() require('telescope').extensions.file_browser.file_browser() end)
vim.keymap.set('n', '<space>fh', function() require('telescope.builtin').help_tags() end)

-- Buffer
vim.keymap.set('n', '<space>bb', function() require('telescope.builtin').buffers() end)
