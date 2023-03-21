local M = {}

M.setup = function()
  require("lvim.lsp.manager").setup "nil_ls"
end

return M
