local M = {}

M.setup = function()
  lvim.builtin.indentlines.options.buftype_exclude = { "help", "terminal", "nofile" }
end

return M
