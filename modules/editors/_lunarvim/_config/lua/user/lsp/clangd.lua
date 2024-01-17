local M = {}

M.setup = function()
  require("lvim.lsp.manager").setup "clangd"

  local formatters = require "lvim.lsp.null-ls.formatters"
  formatters.setup {
    { command = "clang_format" },
  }
end

return M
