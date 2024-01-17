local M = {}

M.setup = function()
  local config = require("user").config

  lvim.builtin.breadcrumbs.active = config.winbar_provider == "navic"
end

return M
