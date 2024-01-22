local wk = require "which-key"
local api = vim.api

local tempdirgroup = api.nvim_create_augroup("tempdir", { clear = true })
-- Do not set undofile for files in /tmp
api.nvim_create_autocmd("BufWritePre", {
  pattern = "/tmp/*",
  group = tempdirgroup,
  callback = function()
    vim.cmd.setlocal "noundofile"
  end,
})

-- Disable spell checking in terminal buffers
local nospell_group = api.nvim_create_augroup("nospell", { clear = true })
api.nvim_create_autocmd("TermOpen", {
  group = nospell_group,
  callback = function()
    vim.wo[0].spell = false
  end,
})

-- LSP
local keymap = vim.keymap

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

--- Don't create a comment string when hitting <Enter> on a comment line
vim.api.nvim_create_autocmd("BufEnter", {
  group = vim.api.nvim_create_augroup("DisableNewLineAutoCommentString", {}),
  callback = function()
    vim.opt.formatoptions = vim.opt.formatoptions - { "c", "r", "o" }
  end,
})

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
    wk.register({
      ["gD"] = { vim.lsp.buf.declaration, "[lsp] go to declaration" },
      ["gd"] = { function() require("trouble").toggle("lsp_definitions") end, "[lsp] go to definition" },
      ["gi"] = { vim.lsp.buf.implementation, "[lsp] go to implementation" },
      ["gr"] = { function() require("trouble").toggle("lsp_references") end, "[lsp] find references" },
      ["K"] = { vim.lsp.buf.hover, "[lsp] hover" },
      ["<C-S-k>"] = { vim.lsp.buf.signature_help, "[lsp] signature help" },
      ["<leader>l"] = {
        name = "lsp",
        p = {
          name = "peek",
          d = { peek_definition, "[lsp] peek definition" },
          t = { peek_type_definition, "[lsp] peek type definition" },
        },
        w = {
          name = "workspace",
          a = { vim.lsp.buf.add_workspace_folder, "[lsp] add workspace folder" },
          r = { vim.lsp.buf.remove_workspace_folder, "[lsp] remove workspace folder" },
          l = {
            function()
              vim.print(vim.lsp.buf.list_workspace_folders())
            end,
            "[lsp] list workspace folders",
          },
        },
        t = { vim.lsp.buf.type_definition, "[lsp] go to type definition" },
        r = { vim.lsp.buf.rename, "[lsp] rename" },
        S = { require("telescope.builtin").lsp_dynamic_workspace_symbols, "[lsp] workspace symbol" },
        s = { require("telescope.builtin").lsp_document_symbols, "[lsp] document symbol" },
        d = { function() require("trouble").toggle("document_diagnostics") end, "[lsp] document diagnostics" },
        D = { function() require("trouble").toggle("workspace_diagnostics") end, "[lsp] workspace diagnostics" },
        a = { vim.lsp.buf.code_action, "[lsp] code action" },
        l = { vim.lsp.codelens.run, "[lsp] run code lens" },
        L = { vim.lsp.codelens.refresh, "[lsp] refresh code lenses" },
        f = {
          function()
            vim.lsp.buf.format { async = true }
          end,
          "[lsp] format buffer",
        },
        h = {
          function()
            vim.lsp.inlay_hint(bufnr)
          end,
          "[lsp] toggle inlay hints",
        },
      },
    }, { buffer = bufnr })

    -- Format on save if supported
    if (client.server_capabilities.documentFormattingProvider) then
      vim.api.nvim_create_autocmd("BufWritePost", {
        buffer = 0,
        callback = function()
          vim.lsp.buf.format()
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
    local group = api.nvim_create_augroup(string.format("lsp-%s-%s", bufnr, client.id), {})
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

-- More examples, disabled by default

-- Toggle between relative/absolute line numbers
-- Show relative line numbers in the current buffer,
-- absolute line numbers in inactive buffers
-- local numbertoggle = api.nvim_create_augroup('numbertoggle', { clear = true })
-- api.nvim_create_autocmd({ 'BufEnter', 'FocusGained', 'InsertLeave', 'CmdlineLeave', 'WinEnter' }, {
--   pattern = '*',
--   group = numbertoggle,
--   callback = function()
--     if vim.o.nu and vim.api.nvim_get_mode().mode ~= 'i' then
--       vim.opt.relativenumber = true
--     end
--   end,
-- })
-- api.nvim_create_autocmd({ 'BufLeave', 'FocusLost', 'InsertEnter', 'CmdlineEnter', 'WinLeave' }, {
--   pattern = '*',
--   group = numbertoggle,
--   callback = function()
--     if vim.o.nu then
--       vim.opt.relativenumber = false
--       vim.cmd.redraw()
--     end
--   end,
-- })
