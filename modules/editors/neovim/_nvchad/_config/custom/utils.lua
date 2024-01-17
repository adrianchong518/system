local M = {}

M.set_indent_width = function(width)
  vim.cmd(string.format("setlocal shiftwidth=%d tabstop=%d expandtab", width, width))
end

M.lisp_ft = {
  "scheme",
  "lisp",
  "clojure",
  "racket",
}

return M
