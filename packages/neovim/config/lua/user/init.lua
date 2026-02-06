local M = {}

M.lisp_ft = {
  'scheme',
  'lisp',
  'clojure',
  'racket',
}

function M.set_indent_width(width)
  vim.opt_local.shiftwidth = width
  vim.opt_local.softtabstop = width
  vim.opt_local.expandtab = true
end

function M.add_mini_clue(clue)
  table.insert(require('mini.clue').config.clues, clue)
end

function M.format_on_save(bufnr, client_id)
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = vim.api.nvim_create_augroup('my.lsp', { clear = false, }),
    buffer = bufnr,
    callback = function()
      vim.lsp.buf.format({ bufnr = bufnr, id = client_id, timeout_ms = 1000, })
    end,
  })
end

return M
