local oil = require('oil')

oil.setup({
  use_default_keymaps = false,
  keymaps = {
    ['g?'] = 'actions.show_help',
    ['<CR>'] = 'actions.select',
    ['<C-v>'] = 'actions.select_vsplit',
    ['<C-s>'] = 'actions.select_split',
    ['<C-t>'] = 'actions.select_tab',
    ['<C-p>'] = 'actions.preview',
    ['<C-c>'] = 'actions.close',
    ['gr'] = 'actions.refresh',
    ['-'] = 'actions.parent',
    ['_'] = 'actions.open_cwd',
    ['`'] = 'actions.cd',
    ['~'] = 'actions.tcd',
    ['gs'] = 'actions.change_sort',
    ['gx'] = 'actions.open_external',
    ['g.'] = 'actions.toggle_hidden',
    ['g\\'] = 'actions.toggle_trash',
    ['gd'] = {
      desc = 'Toggle detail view',
      callback = function()
        local config = require('oil.config')
        if #config.columns == 1 then
          oil.set_columns({ 'permissions', 'size', 'mtime', 'icon', })
        else
          oil.set_columns({ 'icon', })
        end
      end,
    },
  },
  skip_confirm_for_simple_edits = true,
  prompt_save_on_select_new_entry = false,
  constrain_cursor = 'editable',
  view_options = {
    is_always_hidden = function(name, _)
      return name == '..'
    end,
  },
})

vim.keymap.set('n', '-', oil.open, { desc = 'oil', })
vim.keymap.set('n', 'g-', function() oil.open(vim.fn.getcwd()) end, { desc = 'oil (cwd)', })

vim.keymap.set('n', '<leader>fo', function()
  local dir = require('mini.pick').builtin.cli({ command = { 'fd', '-td', '-H', '-E.git', }, })
  if dir ~= nil then
    oil.open(dir)
  end
end, { desc = 'open directory in oil', })
