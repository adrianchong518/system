-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.code_actions.gitsigns,
    },
})

require("lsp-format").setup({})
require("lsp-inlayhints").setup({})

local on_attach = function(client, bufnr)
    -- Set updatetime for CursorHold
    -- 300ms of no cursor movement to trigger CursorHold
    vim.opt.updatetime = 100

    -- Show diagnostic popup on cursor hover
    local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
        callback = function()
            vim.diagnostic.open_float(nil, { focusable = false })
        end,
        group = diag_float_grp,
    })

    require("lsp-format").on_attach(client)
    vim.cmd [[cabbrev wq execute "Format sync" <bar> wq]]

    require("lsp-inlayhints").on_attach(client, bufnr)

    local keymap_opts = { buffer = bufnr }

    -- Goto previous/next diagnostic warning/error
    vim.keymap.set("n", "[g", vim.diagnostic.goto_prev, keymap_opts)
    vim.keymap.set("n", "]g", vim.diagnostic.goto_next, keymap_opts)

    vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
    vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)

    -- Code navigation and shortcuts
    vim.keymap.set("n", "<c-]>", function() require("telescope.builtin").lsp_definitions() end, keymap_opts)
    vim.keymap.set("n", "gD", function() require("telescope.builtin").lsp_implementations() end, keymap_opts)
    vim.keymap.set("n", "1gD", function() require("telescope.builtin").lsp_type_definitions() end, keymap_opts)
    vim.keymap.set("n", "gr", function() require("telescope.builtin").lsp_references() end, keymap_opts)
    vim.keymap.set("n", "go", function() require("telescope.builtin").lsp_document_symbols() end, keymap_opts)
    vim.keymap.set("n", "gO", function() require("telescope.builtin").lsp_workspace_symbols() end, keymap_opts)
    vim.keymap.set("n", "gd", function() require("telescope.builtin").lsp_definitions() end, keymap_opts)

    vim.keymap.set("n", "<space>cd", function() require("telescope.builtin").diagnostics() end, keymap_opts)
end
