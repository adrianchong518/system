local M = {}

M.setup = function()
  lvim.lsp.installer.setup.automatic_installation = false

  ---@diagnostic disable-next-line: missing-parameter
  vim.list_extend(
    lvim.lsp.automatic_configuration.skipped_servers,
    { "rnix", "nil_ls", "rust_analyzer", "zls", "ccls", "clangd" }
  )
end

return M
