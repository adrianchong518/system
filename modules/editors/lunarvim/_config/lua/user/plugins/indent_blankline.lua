local M = {}

M.setup = function()
  lvim.builtin.indentlines.options.buftype_exclude = { "help", "terminal", "nofile" }
  lvim.builtin.indentlines.options.use_treesitter = false
end

return M
