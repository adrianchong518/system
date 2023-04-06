local M = {}

M.setup = function()
  lvim.lsp.installer.setup.automatic_installation = false

  local formatters = require "lvim.lsp.null-ls.formatters"
  formatters.setup {
    { command = "stylua" },
    -- {
    --   command = "prettier",
    --   extra_args = { "--print-width", "100" },
    --   filetypes = { "typescript", "typescriptreact" },
    -- },
  }

  ---@diagnostic disable-next-line: missing-parameter
  vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rnix", "nil_ls", "clangd" })
  lvim.lsp.automatic_configuration.skipped_servers = vim.tbl_filter(function(server)
    return server ~= "ccls"
  end, lvim.lsp.automatic_configuration.skipped_servers)
end

return M