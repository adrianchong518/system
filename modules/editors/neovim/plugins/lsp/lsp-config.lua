-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noinsert,noselect"

-- Avoid showing extra messages when using completion
vim.opt.shortmess = vim.opt.shortmess + "c"


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

-- Goto previous/next diagnostic warning/error
vim.keymap.set("n", "g[", vim.diagnostic.goto_prev)
vim.keymap.set("n", "g]", vim.diagnostic.goto_next)

vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help)

-- Code navigation and shortcuts
vim.keymap.set("n", "<c-]>", function() require('telescope.builtin').lsp_definitions() end)
vim.keymap.set("n", "gD", function() require('telescope.builtin').lsp_implementations() end)
vim.keymap.set("n", "1gD", function() require('telescope.builtin').lsp_type_definitions() end)
vim.keymap.set("n", "gr", function() require('telescope.builtin').lsp_references() end)
vim.keymap.set("n", "g0", function() require('telescope.builtin').lsp_document_symbols() end)
vim.keymap.set("n", "gW", function() require('telescope.builtin').lsp_workspace_symbols() end)
vim.keymap.set("n", "gd", function() require('telescope.builtin').lsp_definitions() end)

vim.keymap.set("n", "<space>cd", function() require('telescope.builtin').diagnostics() end)
