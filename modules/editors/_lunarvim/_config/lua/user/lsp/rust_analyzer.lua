local M = {}

M.setup = function()
  require("lvim.lsp.manager").setup("rust_analyzer", {
    settings = {
      ["rust-analyzer"] = {
        files = {
          -- https://github.com/rust-lang/rust-analyzer/issues/12613
          excludeDirs = { ".direnv" },
        },
      },
    },
  })
end

return M
