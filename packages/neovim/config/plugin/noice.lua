--[[
local noice = require "noice"

noice.setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },

  routes = {
    {
      filter = { event = "msg_show", kind = "", find = "written" },
      opts = { skip = true },
    },
    {
      view = "notify",
      filter = { event = "msg_showmode" },
    },
  },

  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = true,
    lsp_doc_border = true,
  },
})

vim.keymap.set({ "n", "i", "s" }, "<C-f>", function()
  if not require("noice.lsp").scroll(4) then
    return "<C-f>"
  end
end, { silent = true, expr = true })
vim.keymap.set({ "n", "i", "s" }, "<C-b>", function()
  if not require("noice.lsp").scroll(-4) then
    return "<C-b>"
  end
end, { silent = true, expr = true })
]]
