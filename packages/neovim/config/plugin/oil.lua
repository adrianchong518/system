local oil = require("oil")

oil.setup({
  use_default_keymaps = false,
  keymaps = {
    ["g?"] = "actions.show_help",
    ["<CR>"] = "actions.select",
    ["<C-v>"] = "actions.select_vsplit",
    ["<C-s>"] = "actions.select_split",
    ["<C-t>"] = "actions.select_tab",
    ["<C-p>"] = "actions.preview",
    ["<C-c>"] = "actions.close",
    ["gr"] = "actions.refresh",
    ["-"] = "actions.parent",
    ["_"] = "actions.open_cwd",
    ["`"] = "actions.cd",
    ["~"] = "actions.tcd",
    ["gs"] = "actions.change_sort",
    ["gx"] = "actions.open_external",
    ["g."] = "actions.toggle_hidden",
    ["g\\"] = "actions.toggle_trash",
    ["gd"] = {
      desc = "Toggle detail view",
      callback = function()
        local config = require("oil.config")
        if #config.columns == 1 then
          oil.set_columns({ "permissions", "size", "mtime", "icon" })
        else
          oil.set_columns({ "icon" })
        end
      end,
    },
  },
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = false,
  constrain_cursor = "editable",
  view_options = {
    is_always_hidden = function(name, _)
      return name == ".."
    end
  }
})

vim.keymap.set("n", "-", function() oil.open() end, { desc = "Open parent directory" })
vim.keymap.set("n", "g-", function() oil.toggle_float() end, { desc = "Toggle floating parent directory" })
