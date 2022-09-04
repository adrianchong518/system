-- FZF SETTINGS
-- Customize fzf colors to match your color scheme
-- fzf#wrap translates this to a set of `--color` options
vim.g.fzf_colors = {
    fg = { "fg", "Normal" },
    bg = { "bg", "Normal" },
    hl = { "fg", "Comment" },
    ["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
    ["bg+"] = { "bg", "CursorLine", "CursorColumn" },
    ["hl+"] = { "fg", "Statement" },
    info = { "fg", "PreProc" },
    border = { "fg", "Normal" },
    prompt = { "fg", "Conditional" },
    pointer = { "fg", "Exception" },
    marker = { "fg", "Keyword" },
    spinner = { "fg", "Label" },
    header = { "fg", "Comment" },
}

-- Enable per-command history
-- - History files will be stored in the specified directory
-- - When set, CTRL-N and CTRL-P will be bound to 'next-history' and
--   'previous-history' instead of 'down' and 'up'.
vim.g.fzf_history_dir = "~/.local/share/fzf-history"

vim.api.nvim_set_keymap("n", "<space>b", ":Buffers<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<space>f", ":call fzf#vim#files('.', {'options': '--prompt \"\"'})<CR>",
    { noremap = true, silent = true })