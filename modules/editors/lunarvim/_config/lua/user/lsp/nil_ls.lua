local M = {}

M.setup = function()
  require("lvim.lsp.manager").setup("nil_ls", {
    settings = {
      ["nil"] = {
        formatting = { command = { "nixpkgs-fmt" } },
      },
    },
  })
end

return M
