local M = {}

M.lisp_ft = {
  "scheme",
  "lisp",
  "clojure",
  "racket",
}

function M.set_indent_width(width)
  vim.cmd(string.format("setlocal shiftwidth=%d tabstop=%d expandtab", width, width))
end

return M
