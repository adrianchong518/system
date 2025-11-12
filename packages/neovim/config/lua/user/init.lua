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

return M
