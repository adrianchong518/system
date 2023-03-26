local M = {}

M.setup = function(config)
  M.config = config

  require("user.plugins").setup()
  require("user.lsp").setup()

  require("user.options").setup()
  require("user.keymap").setup()
end

return M
