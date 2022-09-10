-- Speed up!
require("impatient")

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
    vim.cmd([[%s/\s\+$//e]])
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

-- Set textwidth etc.
vim.o.colorcolumn = "+1"
vim.o.formatoptions = "tcqjn"

function setTextWidth(filetype, tw)
    vim.cmd(string.format("autocmd FileType %s setlocal textwidth=%d", filetype, tw))
    vim.cmd(string.format("autocmd FileType %s highlight OverLength ctermbg=darkgrey guibg=#592929", filetype))
    vim.cmd(string.format("autocmd FileType %s match OverLength /\\%%%dv.*/", filetype, tw+1))
end

setTextWidth("markdown", 80)
setTextWidth("c", 80)
setTextWidth("cpp", 80)
setTextWidth("rust", 120)

-- Plenary
require"plenary.filetype".add_file("plenary-types")

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

--- Panels ---------
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
require("telescope").setup {
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
                ["<esc>"] = "close",
                ["<C-k>"] = "move_selection_previous",
                ["<C-j>"] = "move_selection_next",
            },
        },
    },
    extensions = {
        coc = {
            prefer_locations = true,
        },
        fzf = {
            fuzzy = false,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        file_browser = {
            grouped = true,
            hijack_netrw = true,
        },
    },
}

require("telescope").load_extension("fzf")
require("telescope").load_extension("coc")
require("telescope").load_extension("file_browser")

--- Editor Features ----------
require("nvim-surround").setup()
require("nvim_comment").setup()
require("nvim-autopairs").setup {}
require("todo-comments").setup()

require("indent_blankline").setup {
    show_current_context = true,
}
vim.cmd("highlight IndentBlanklineContextChar guifg=#A8A8A8 gui=nocombine")

require("illuminate").configure({
    filetypes_denylist = {
        "dirvish",
        "fugitive",
        "NvimTree",
        "tagbar",
        "TelescopePrompt",
        "gitcommit",
        "markdown",
        "help",
    },
})

require("gitsigns").setup({
    current_line_blame = true,
    numhl = true,
    on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then return ']c' end
          vim.schedule(function() gs.next_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        map('n', '[c', function()
          if vim.wo.diff then return '[c' end
          vim.schedule(function() gs.prev_hunk() end)
          return '<Ignore>'
        end, {expr=true})

        -- Actions
        map({'n', 'v'}, '<space>gs', ':Gitsigns stage_hunk<CR>')
        map({'n', 'v'}, '<space>gr', ':Gitsigns reset_hunk<CR>')
        map('n', '<space>gS', gs.stage_buffer)
        map('n', '<space>gu', gs.undo_stage_hunk)
        map('n', '<space>gR', gs.reset_buffer)
        map('n', '<space>gp', gs.preview_hunk)
        map('n', '<space>gb', function() gs.blame_line{full=true} end)
        map('n', '<space>tgb', gs.toggle_current_line_blame)
        map('n', '<space>gd', gs.diffthis)
        map('n', '<space>gD', function() gs.diffthis('~') end)
        map('n', '<space>tgd', gs.toggle_deleted)

        -- Text object
        map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    end,
})

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

require"treesitter-context".setup{
    patterns = {
        rust = {
            "impl_item",
            "struct",
            "enum",
            "mod",
        }
    }
}

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevelstart = 99

--- Keymappings ----------
vim.keymap.set("n", [[\\]], ":noh<CR>")

-- coc --
vim.keymap.set("n", "[g", "<Plug>(coc-diagnostic-prev)", { silent = true })
vim.keymap.set("n", "]g", "<Plug>(coc-diagnostic-next)", { silent = true })

vim.keymap.set("n", "K", ":call ShowDocumentation()<cr>", { silent = true })

-- Use <c-space> to trigger completion.
vim.keymap.set("i", "<c-space>", "coc#refresh()", { silent = true, expr = true })

-- GoTo code navigation.
vim.keymap.set("n", "gd", ":Telescope coc definitions<cr>", { silent = true})
vim.keymap.set("n", "gy", ":Telescope coc type-definitions<cr>", { silent = true})
vim.keymap.set("n", "gi", ":Telescope coc implementations<cr>", { silent = true})
vim.keymap.set("n", "gr", ":Telescope coc references<cr>", { silent = true})

-- Selection ranges (Requires "textDocument/selectionRange" support of language server.)
vim.keymap.set({"n", "x"}, "<C-s>", "<Plug>(coc-range-select)", { silent = true })

-- Map function and class text objects
-- NOTE: Requires "textDocument.documentSymbol" support from the language server.
vim.keymap.set({"x", "o"}, "if", "<Plug>(coc-funcobj-i)")
vim.keymap.set({"x", "o"}, "af", "<Plug>(coc-funcobj-a)")
vim.keymap.set({"x", "o"}, "ic", "<Plug>(coc-classobj-i)")
vim.keymap.set({"x", "o"}, "ac", "<Plug>(coc-classobj-a)")

-- Toggle --
vim.keymap.set("n", "<space>to", ":TagbarToggle<cr>", { silent = true })
vim.keymap.set("n", "<space>tO", ":TagbarOpenAutoClose<cr>", { silent = true })
vim.keymap.set("n", "<space>te", function() require"nvim-tree".toggle(false, true) end, { silent = true })
vim.keymap.set("n", "<space>tE", ":NvimTreeFocus<cr>", { silent = true })

-- Find --
vim.keymap.set("n", "<space>ff", function() require("telescope.builtin").find_files() end)
vim.keymap.set("n", "<space>fg", function() require("telescope.builtin").live_grep() end)
vim.keymap.set("n", "<space>fb", function() require("telescope").extensions.file_browser.file_browser() end)
vim.keymap.set("n", "<space>fh", function() require("telescope.builtin").help_tags() end)

-- NOTE: Filtering by keywords seems broken
vim.keymap.set("n", "<space>ft", ":TodoTelescope<cr>")

-- Buffer --
vim.keymap.set("n", "<space>bb", function() require("telescope.builtin").buffers() end)

-- Code --
-- Symbol renaming
vim.keymap.set("n", "<space>cr", "<Plug>(coc-rename)")

-- Formatting selected code
vim.keymap.set({"x", "n"}, "<space>cf", "<Plug>(coc-format-selected)")
vim.keymap.set("n", "<space>cF", ":Format<cr>")

-- Applying codeAction
vim.keymap.set({"x", "n"}, "<space>ca", "<Plug>(coc-codeaction-selected)")
vim.keymap.set("n", "<space>cA", "<Plug>(coc-codeaction)")

-- AutoFix
vim.keymap.set("n", "<space>cq", "<Plug>(coc-fix-current)")

-- Code lens
vim.keymap.set("n", "<space>cl", "<Plug>(coc-codelens-action)")

-- Diagnostics
vim.keymap.set("n", "<space>cd", ":Telescope coc diagnostics<cr>", { silent = true, nowait = true })
vim.keymap.set("n", "<space>cD", ":Telescope coc workspace_diagnostics<cr>", { silent = true, nowait = true })

-- Symbols
vim.keymap.set("n", "<space>co", ":Telescope coc document_symbols<cr>", { silent = true, nowait = true })
vim.keymap.set("n", "<space>cs", ":Telescope coc workspace_symbols<cr>", { silent = true, nowait = true })

-- Misc
vim.keymap.set("n", "<space>ce", ":<C-u>CocList extensions<cr>", { silent = true, nowait = true })
vim.keymap.set("n", "<space>cc", ":Telescope coc commands<cr>", { silent = true, nowait = true })

