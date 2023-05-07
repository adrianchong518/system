local M = {}

M.setup = function()
  require("lvim.lsp.manager").setup "zls"
end

return M
