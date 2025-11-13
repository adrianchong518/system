require('lazydev').setup()

require('blink-cmp').setup {
  sources = {
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'copilot', },
    providers = {
      lazydev = { name = 'LazyDev', module = 'lazydev.integrations.blink', score_offset = 100, },
      copilot = { name = 'copilot', module = 'blink-copilot', async = true, },
    },
  },

  keymap = {
    ['<M-space>'] = { 'show', 'show_documentation', 'hide_documentation', },
  },

  completion = {
    list = {
      selection = { preselect = false, auto_insert = false, },
    },
    documentation = {
      auto_show = true,
      auto_show_delay_ms = 500,
    },
  },

  signature = { enabled = true, },
}

vim.diagnostic.config {
  virtual_text = { current_line = false, },
  virtual_lines = { current_line = true, },
}

vim.lsp.enable {
  'nil_ls',
  'copilot',
  'lua_ls',
  'clangd',
  'zls',
  'racket_langserver',
  'dockerls',
  'texlab',
  'yamlls',
  'ruff',
}

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      format = {
        defaultConfig = {
          quote_style = 'single',
          trailing_table_separator = 'always',
        },
      },
    },
  },
})

vim.lsp.config('nil_ls', {
  settings = {
    ['nil'] = {
      formatting = { command = { 'nixpkgs-fmt', }, },
    },
  },
})

local null_ls = require 'null-ls'
null_ls.setup {
  sources = {
    null_ls.builtins.formatting.prettierd,
    null_ls.builtins.formatting.black,
  },
}

-- Suppress specific LSP notifications
local notify = vim.notify
---@diagnostic disable-next-line: duplicate-set-field
vim.notify = function(msg, ...)
  if msg:find('Format request failed') then
    return
  end
  notify(msg, ...)
end

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('my.lsp', {}),
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

    require('user').add_mini_clue { mode = 'n', keys = '<leader>l', desc = '+lsp', }

    local miniextra = require 'mini.extra'

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'definition', })
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'declaration', })
    vim.keymap.set('n', 'gi', function() miniextra.pickers.lsp({ scope = 'implementation', }) end,
      { desc = 'implementation', })
    vim.keymap.set('n', 'gr', function() miniextra.pickers.lsp({ scope = 'references', }) end,
      { desc = 'declaration', })

    vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, { desc = 'type definition', })
    vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, { desc = 'rename', })
    vim.keymap.set('n', '<leader>la', vim.lsp.buf.code_action, { desc = 'code action', })
    vim.keymap.set('n', '<leader>lf', vim.diagnostic.open_float, { desc = 'diagnostic', })

    vim.keymap.set('n', '<leader>ld', function() miniextra.pickers.diagnostic({ scope = 'current', }) end,
      { desc = 'document symbols', })
    vim.keymap.set('n', '<leader>lD', function() miniextra.pickers.diagnostic({ scope = 'all', }) end,
      { desc = 'workspace symbols', })
    vim.keymap.set('n', '<leader>ls', function() miniextra.pickers.lsp({ scope = 'document_symbol', }) end,
      { desc = 'document symbols', })
    vim.keymap.set('n', '<leader>lS', function()
      miniextra.pickers.lsp({ scope = 'workspace_symbol', symbol_query = vim.fn.input('Symbol: '), })
    end, { desc = 'workspace symbols', })

    if not client:supports_method('textDocument/willSaveWaitUntil')
        and client:supports_method('textDocument/formatting') then
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = vim.api.nvim_create_augroup('my.lsp', { clear = false, }),
        buffer = args.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000, })
        end,
      })
    end
  end,
})
