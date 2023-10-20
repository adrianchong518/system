local M = {}

M.opts = {
  fast_wrap = {},
  disable_filetype = { "TelescopePrompt", "vim" },
}

M.config = function(_, opts)
  require("nvim-autopairs").setup(opts)

  -- setup cmp for autopairs
  local cmp_autopairs = require "nvim-autopairs.completion.cmp"
  require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

  local lisp_ft = require("custom.utils").lisp_ft
  require("nvim-autopairs").get_rules("'")[1].not_filetypes = lisp_ft
  require("nvim-autopairs").get_rules("`")[1].not_filetypes = lisp_ft
end

return M
