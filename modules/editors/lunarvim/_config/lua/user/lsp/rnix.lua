local M = {}

M.setup = function()
  require("lvim.lsp.manager").setup "rnix"
end

return M
