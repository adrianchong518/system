local M = {}

M.setup = function()
  lvim.builtin.treesitter.auto_install = true
  lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }
end

return M
