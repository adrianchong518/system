-- Speed up!
require('impatient')

--- General Vim Settings ----------
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.encoding = "utf-8"
vim.o.wildmenu = true
vim.o.lazyredraw = true
vim.o.ruler = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.mouse = "a"
vim.o.scrolloff = 5
vim.o.cursorline = true
vim.o.updatetime = 300
vim.o.signcolumn = "yes"

vim.cmd([[
    set nobackup
    set nowritebackup
]])

-- Strip trailing whitespaces
function vim.fn.stripTrailingWhitespace()
    local l = vim.fn.line(".")
    local c = vim.fn.col(".")
    vim.cmd("%s/\\s\\+$//e")
    vim.fn.cursor(l, c)
end
vim.cmd("autocmd BufWritePre * :lua vim.fn.stripTrailingWhitespace()")

-- Set indentation
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true

function setTabWidth(filetype, width)
    vim.cmd(string.format("autocmd FileType %s setlocal shiftwidth=%d softtabstop=%d expandtab", filetype, width, width))
end

setTabWidth("nix", 2)
setTabWidth("c", 2)
setTabWidth("cpp", 2)
setTabWidth("scheme", 2)
setTabWidth("haskell", 2)
setTabWidth("markdown", 2)

-- Plenary
require'plenary.filetype'.add_file('plenary-types')

--- UI / Theming ----------
if vim.fn.empty("$TMUX") then
    if vim.fn.has("nvim") then
        vim.cmd("let $NVIM_TUI_ENABLE_TRUE_COLOR=1")
    end
    if vim.fn.has("termguicolors") then
        vim.opt.termguicolors = true
    end
end

vim.cmd([[
  syntax enable
  colorscheme one
]])

-- Lualine
require("lualine").setup({
    options = { theme = "onedark" },
})

--- Panels ----------
-- nvim-tree
require("nvim-tree").setup({
    view = {
        width = 50,
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

    update_focused_file = {
        enable = true,
    },
})

-- Telescope
require("telescope").load_extension("fzf")
require("telescope").load_extension("coc")

require("telescope").setup {
    defaults = {
        layout_strategy = "flex",
        layout_config = {
            width = { 0.8, max = 235 },
            height = { 0.95, max = 50 },
            flip_columns = 150
        },
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

--- Editor Features ----------
require("nvim-surround").setup()
require('Comment').setup()
require("nvim-autopairs").setup {}

require("indent_blankline").setup {
    use_treesitter = true,
    show_current_context = true,
}
vim.cmd("highlight IndentBlanklineContextChar guifg=#A8A8A8 gui=nocombine")

--- Language / LSP ----------
-- Tree Sitter
require("nvim-treesitter.configs").setup({
    highlight = {
        enable = true,
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = "gnn",
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "grm",
        },
    },
    indent = {
        enable = true,
    },
})

require'treesitter-context'.setup{
    patterns = {
        rust = {
            'impl_item',
            'struct',
            'enum',
            'mod'
        }
    }
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99

--- Keymappings ----------
-- Functional wrapper for mapping custom keybindings
-- mode (as in Vim modes like Normal/Insert mode)
-- lhs (the custom keybinds you need)
-- rhs (the commands or existing keybinds to customise)
-- opts (additional options like <silent>/<noremap>, see :h map-arguments for more info on it)
function map(mode, lhs, rhs, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend("force", options, opts)
    end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map("n", "<leader>\\", ":noh<CR>", { })

-- coc --
map("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
map("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

map("n", "K", ":call ShowDocumentation()<cr>", { silent = true })

-- Use <c-space> to trigger completion.
map("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

-- GoTo code navigation.
map("n", "gd", ":Telescope coc definitions<cr>", { silent = true})
map("n", "gy", ":Telescope coc type-definitions<cr>", { silent = true})
map("n", "gi", ":Telescope coc implementations<cr>", { silent = true})
map("n", "gr", ":Telescope coc references<cr>", { silent = true})

-- Remap <C-f> and <C-b> for scroll float windows/popups.
map("n", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "\\<C-f>"', { silent = true, nowait = true, expr = true })
map("n", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "\\<C-b>"', { silent = true, nowait = true, expr = true })
map("i", "<C-f>", 'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(1)\\<cr>" : "\\<Right>"', { silent = true, nowait = true, expr = true })
map("i", "<C-b>", 'coc#float#has_scroll() ? "\\<c-r>=coc#float#scroll(0)\\<cr>" : "\\<Left>"', { silent = true, nowait = true, expr = true })
map("v", "<C-f>", 'coc#float#has_scroll() ? coc#float#scroll(1) : "\\<C-f>"', { silent = true, nowait = true, expr = true })
map("v", "<C-b>", 'coc#float#has_scroll() ? coc#float#scroll(0) : "\\<C-b>"', { silent = true, nowait = true, expr = true })

-- Selection ranges (Requires 'textDocument/selectionRange' support of language server.)
map("n", "<C-s>", "<Plug>(coc-range-select)", { silent = true })
map("x", "<C-s>", "<Plug>(coc-range-select)", { silent = true })

-- Map function and class text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server.
map("x", "if", "<Plug>(coc-funcobj-i)", { })
map("o", "if", "<Plug>(coc-funcobj-i)", { })
map("x", "af", "<Plug>(coc-funcobj-a)", { })
map("o", "af", "<Plug>(coc-funcobj-a)", { })
map("x", "ic", "<Plug>(coc-classobj-i)", { })
map("o", "ic", "<Plug>(coc-classobj-i)", { })
map("x", "ac", "<Plug>(coc-classobj-a)", { })
map("o", "ac", "<Plug>(coc-classobj-a)", { })

-- Toggle --
map("n", "<space>to", ":TagbarToggle<cr>", { silent = true })
map("n", "<space>tO", ":TagbarOpenAutoClose<cr>", { silent = true })
map("n", "<space>te", ":lua require'nvim-tree'.toggle(false, true)<cr>", { silent = true })
map("n", "<space>tE", ":NvimTreeFocus<cr>", { silent = true })

-- Find --
map("n", "<space>ff", "<cmd>lua require('telescope.builtin').find_files()<cr>", { })
map("n", "<space>fg", "<cmd>lua require('telescope.builtin').live_grep()<cr>", { })
map("n", "<space>fb", "<cmd>lua require('telescope.builtin').buffers()<cr>", { })
map("n", "<space>fh", "<cmd>lua require('telescope.builtin').help_tags()<cr>", { })

-- Buffer --
map("n", "<space>bb", "<cmd>lua require('telescope.builtin').buffers()<cr>", { })

-- Code --
-- Symbol renaming
map("n", "<space>cr", "<Plug>(coc-rename)", { })

-- Formatting selected code
map("x", "<space>cf", "<Plug>(coc-format-selected)", { })
map("n", "<space>cf", "<Plug>(coc-format-selected)", { })
map("n", "<space>cF", ":Format<cr>", { })

-- Applying codeAction
map("x", "<space>ca", "<Plug>(coc-codeaction-selected)", { })
map("n", "<space>ca", "<Plug>(coc-codeaction-selected)", { })
map("n", "<space>cA", "<Plug>(coc-codeaction)", { })

-- AutoFix
map("n", "<space>cq", "<Plug>(coc-fix-current)", { })

-- Code lens
map("n", "<space>cl", "<Plug>(coc-codelens-action)", { })

-- Diagnostics
map("n", "<space>cd", ":Telescope coc diagnostics<cr>", { silent = true, nowait = true })
map("n", "<space>cD", ":Telescope coc workspace_diagnostics<cr>", { silent = true, nowait = true })

-- Symbols
map("n", "<space>co", ":Telescope coc document_symbols<cr>", { silent = true, nowait = true })
map("n", "<space>cs", ":Telescope coc workspace_symbols<cr>", { silent = true, nowait = true })

-- Misc
map("n", "<space>ce", ":<C-u>CocList extensions<cr>", { silent = true, nowait = true })
map("n", "<space>cc", ":Telescope coc commands<cr>", { silent = true, nowait = true })

