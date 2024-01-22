require("nvim-autopairs").setup {
  fast_wrap = {},
  disable_filetype = { "TelescopePrompt", "vim" },
}

local cmp_autopairs = require "nvim-autopairs.completion.cmp"
require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())

local lisp_ft = require("user").lisp_ft
require("nvim-autopairs").get_rules("'")[1].not_filetypes = lisp_ft
require("nvim-autopairs").get_rules("`")[1].not_filetypes = lisp_ft
