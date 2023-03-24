local M = {}

M.setup = function()
  require("lvim.lsp.manager").setup "ccls"
end

return M
