---@mod user.lsp
---
---@brief [[
---LSP related functions
---@brief ]]

local M = {}

---Gets a 'ClientCapabilities' object, describing the LSP client capabilities
---Extends the object with capabilities provided by plugins.
---@return lsp.ClientCapabilities
function M.make_client_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  -- Add com_nvim_lsp capabilities
  local cmp_lsp = require "cmp_nvim_lsp"

  local cmp_lsp_capabilities = cmp_lsp.default_capabilities()
  capabilities = vim.tbl_deep_extend("keep", capabilities, cmp_lsp_capabilities)

  capabilities.textDocument.foldingRange = {
    dynamicRegistration = false,
    lineFoldingOnly = true,
  }
  return capabilities
end

M.servers = {
  { name = "clangd" },
  { name = "zls" },
  { name = "racket_langserver" },
  { name = "dockerls" },
  {
    name = "pylsp",
    settings = {
      ["pylsp"] = {
        configurationSources = { "flake8" },
        plugins = {
          autopep8 = { enabled = false },
          pycodestyle = { enabled = false },
          flake8 = { enabled = true },
          black = { enabled = true },
        },
      },
    },
  },
  {
    name = "nil_ls",
    override_autoformat = true,
    settings = {
      ["nil"] = {
        formatting = { command = { "nixpkgs-fmt" } },
      },
    },
  },
  {
    name = "lua_ls",
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global, etc.
          globals = {
            "vim",
            "describe",
            "it",
            "assert",
            "stub",
          },
          disable = {
            "duplicate-set-field",
          },
        },
        workspace = {
          checkThirdParty = false,
        },
        telemetry = {
          enable = false,
        },
        hint = { -- inlay hints (supported in Neovim >= 0.10)
          enable = true,
        },
      },
    },
  },
  { name = "arduino_language_server" }
}

return M
