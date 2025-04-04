local cmp = require "cmp"
local lspkind = require "lspkind"
local luasnip = require "luasnip"

vim.opt.completeopt = { "menu", "menuone", "noselect" }

lspkind.init {
  symbol_map = {
    Copilot = "",
  },
}
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

local function has_words_before()
  local unpack_ = unpack or table.unpack
  local line, col = unpack_(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match "%s" == nil
end

---@param source string|table
local function complete_with_source(source)
  if type(source) == "string" then
    cmp.complete { config = { sources = { { name = source } } } }
  elseif type(source) == "table" then
    cmp.complete { config = { sources = { source } } }
  end
end

cmp.setup {
  preselect = cmp.PreselectMode.None,
  completion = {
    completeopt = "menu,menuone,noselect",
    -- autocomplete = false,
  },
  formatting = {
    format = lspkind.cmp_format {
      mode = "symbol_text",
      with_text = true,
      maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
      ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

      menu = {
        buffer = "[BUF]",
        nvim_lsp = "[LSP]",
        nvim_lsp_signature_help = "[LSP]",
        nvim_lsp_document_symbol = "[LSP]",
        nvim_lua = "[API]",
        path = "[PATH]",
        luasnip = "[SNIP]",
      },
    },
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-b>"] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.scroll_docs(-4)
      else
        complete_with_source "buffer"
      end
    end, { "i", "c", "s" }),
    ["<C-f>"] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.scroll_docs(4)
      else
        complete_with_source "path"
      end
    end, { "i", "c", "s" }),
    ["<C-n>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
        -- expand_or_jumpable(): Jump outside the snippet region
        -- expand_or_locally_jumpable(): Only jump inside the snippet region
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "c", "s" }),
    ["<C-p>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "c", "s" }),
    -- toggle completion
    ["<C-e>"] = cmp.mapping(function(_)
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end, { "i", "c", "s" }),
    ["<C-y>"] = cmp.mapping.confirm {
      select = true,
    },
    ["<CR>"] = cmp.mapping {
      i = function(fallback)
        if cmp.visible() and cmp.get_active_entry() then
          cmp.confirm { behavior = cmp.ConfirmBehavior.Replace, select = false }
        else
          fallback()
        end
      end,
      s = cmp.mapping.confirm { select = true },
      c = cmp.mapping.confirm { behavior = cmp.ConfirmBehavior.Replace, select = true },
    },
    ["<Tab>"] = function(fallback)
      fallback()
    end,
    ["<S-Tab>"] = function(fallback)
      fallback()
    end,
  },
  sources = cmp.config.sources {
    -- The insertion order influences the priority of the sources
    { name = "copilot" },
    { name = "nvim_lsp" },
    { name = "nvim_lsp_signature_help" },
    { name = "buffer" },
    { name = "path" },
  },
  enabled = function()
    return vim.bo[0].buftype ~= "prompt"
  end,
  experimental = {
    native_menu = false,
    ghost_text = false,
  },
}

cmp.setup.filetype("lua", {
  sources = cmp.config.sources {
    { name = "nvim_lua" },
    { name = "nvim_lsp", keyword_length = 3 },
    { name = "path" },
  },
})
