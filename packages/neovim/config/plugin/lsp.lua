local lspconfig = require("lspconfig")

require("neodev.lsp").setup()

local function preview_location_callback(_, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  local buf, _ = vim.lsp.util.preview_location(result[1])
  if buf then
    local cur_buf = vim.api.nvim_get_current_buf()
    vim.bo[buf].filetype = vim.bo[cur_buf].filetype
  end
end

local function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, "textDocument/definition", params, preview_location_callback)
end

local function peek_type_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, "textDocument/typeDefinition", params, preview_location_callback)
end

local function on_attach_builder(lsp)
  return function(client, bufnr)
    if lsp.override_autoformat then
      client.server_capabilities.documentFormattingProvider = true
    end
  end
end

for _, lsp in ipairs(require("user.lsp").servers) do
  lspconfig[lsp.name].setup {
    capabilities = require("user.lsp").capabilities,
    on_attach = on_attach_builder(lsp),
    settings = lsp.settings,
  }
end

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local bufnr = ev.buf
    local client = vim.lsp.get_client_by_id(ev.data.client_id)

    -- Attach plugins
    require("nvim-navic").attach(client, bufnr)

    vim.cmd.setlocal "signcolumn=yes"
    vim.bo[bufnr].bufhidden = "hide"

    -- Enable completion triggered by <c-x><c-o>
    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
    require("which-key").add({
      buffer = bufnr,

      { "gD",          vim.lsp.buf.declaration,                                                   desc = "[lsp] go to declaration" },
      { "gd",          require("telescope.builtin").lsp_definitions,                              desc = "[lsp] go to definition" },
      { "gi",          vim.lsp.buf.implementation,                                                desc = "[lsp] go to implementation" },
      { "gr",          require("telescope.builtin").lsp_references,                               desc = "[lsp] find references" },
      { "K",           vim.lsp.buf.hover,                                                         desc = "[lsp] hover" },
      { "<C-S-k>",     vim.lsp.buf.signature_help,                                                desc = "[lsp] signature help" },

      { "<leader>l",   group = "lsp" },

      { "<leader>lp",  group = "peek" },
      { "<leader>lpd", peek_definition,                                                           desc = "[lsp] peek definition" },
      { "<leader>lpt", peek_type_definition,                                                      desc = "[lsp] peek type definition" },

      { "<leader>lw",  group = "workspace" },
      { "<leader>lwa", vim.lsp.buf.add_workspace_folder,                                          desc = "[lsp] add workspace folder" },
      { "<leader>lwr", vim.lsp.buf.remove_workspace_folder,                                       desc = "[lsp] remove workspace folder" },
      { "<leader>lwl", function() vim.print(vim.lsp.buf.list_workspace_folders()) end,            desc = "[lsp] list workspace folders" },

      { "<leader>lt",  vim.lsp.buf.type_definition,                                               desc = "[lsp] go to type definition" },
      { "<leader>lr",  vim.lsp.buf.rename,                                                        desc = "[lsp] rename" },
      { "<leader>lS",  require("telescope.builtin").lsp_dynamic_workspace_symbols,                desc = "[lsp] workspace symbol" },
      { "<leader>ls",  require("telescope.builtin").lsp_document_symbols,                         desc = "[lsp] document symbol" },
      { "<leader>ld",  function() require("telescope.builtin").open("document_diagnostics") end,  desc = "[lsp] document diagnostics" },
      { "<leader>lD",  function() require("telescope.builtin").open("workspace_diagnostics") end, desc = "[lsp] workspace diagnostics" },
      { "<leader>la",  vim.lsp.buf.code_action,                                                   desc = "[lsp] code action" },
      { "<leader>ll",  vim.lsp.codelens.run,                                                      desc = "[lsp] run code lens" },
      { "<leader>lL",  vim.lsp.codelens.refresh,                                                  desc = "[lsp] refresh code lenses" },
      { "<leader>lF",  function() vim.lsp.buf.format { async = true } end,                        desc = "[lsp] format buffer" },
      { "<leader>lh",  function() vim.lsp.inlay_hint(bufnr) end,                                  desc = "[lsp] toggle inlay hints" },
    })

    -- Format on save if supported
    if (client.server_capabilities.documentFormattingProvider) then
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = 0,
        callback = function()
          vim.lsp.buf.format { async = false }
        end,
      })
    end

    -- Auto-refresh code lenses
    if not client then
      return
    end
    local function buf_refresh_codeLens()
      vim.schedule(function()
        if client.server_capabilities.codeLensProvider then
          vim.lsp.codelens.refresh()
          return
        end
      end)
    end
    local group = vim.api.nvim_create_augroup(string.format("lsp-%s-%s", bufnr, client.id), {})
    if client.server_capabilities.codeLensProvider then
      vim.api.nvim_create_autocmd({ "InsertLeave", "BufWritePost", "TextChanged" }, {
        group = group,
        callback = buf_refresh_codeLens,
        buffer = bufnr,
      })
      buf_refresh_codeLens()
    end
  end,
})
