--- Keymap

vim.keymap.set('n', [[\\]], ':noh<CR>')


-- Navigation --
vim.keymap.set('n', '[g', '<Plug>(coc-diagnostic-prev)', { silent = true })
vim.keymap.set('n', ']g', '<Plug>(coc-diagnostic-next)', { silent = true })

-- Text objects
-- NOTE: Requires 'textDocument.documentSymbol' support from the language server.
vim.keymap.set({'x', 'o'}, 'if', '<Plug>(coc-funcobj-i)')
vim.keymap.set({'x', 'o'}, 'af', '<Plug>(coc-funcobj-a)')
vim.keymap.set({'x', 'o'}, 'ic', '<Plug>(coc-classobj-i)')
vim.keymap.set({'x', 'o'}, 'ac', '<Plug>(coc-classobj-a)')


-- coc --
vim.keymap.set('n', 'K', ':call ShowDocumentation()<cr>', { silent = true })
-- Use <c-space> to trigger completion.
vim.keymap.set('i', '<c-space>', 'coc#refresh()', { silent = true, expr = true })
-- Selection ranges (Requires 'textDocument/selectionRange' support of language server.)
vim.keymap.set({'n', 'x'}, '<C-s>', '<Plug>(coc-range-select)', { silent = true })


-- Code --
-- Symbol renaming
vim.keymap.set('n', '<space>cr', '<Plug>(coc-rename)')

-- Formatting selected code
vim.keymap.set({'x', 'n'}, '<space>cf', '<Plug>(coc-format-selected)')
vim.keymap.set('n', '<space>cF', ':Format<cr>')

-- Applying codeAction
vim.keymap.set({'x', 'n'}, '<space>ca', '<Plug>(coc-codeaction-selected)')
vim.keymap.set('n', '<space>cA', '<Plug>(coc-codeaction)')

-- AutoFix
vim.keymap.set('n', '<space>cq', '<Plug>(coc-fix-current)')

-- Code lens
vim.keymap.set('n', '<space>cl', '<Plug>(coc-codelens-action)')

-- Misc
vim.keymap.set('n', '<space>ce', ':<C-u>CocList extensions<cr>', { silent = true, nowait = true })

