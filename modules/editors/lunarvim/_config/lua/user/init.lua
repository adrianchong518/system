local M = {}

M.setup = function(config)
  M.config = config

  require("user.options").setup()
  require("user.keymap").setup()

  require("user.plugins").setup()
  require("user.lsp").setup()
end

return M
