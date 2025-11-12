local mocha = require('catppuccin.palettes').get_palette 'mocha'

require('window-picker').setup {
  hint = 'floating-big-letter',
  selection_chars = 'TNSERIAODHVKCM',

  filter_rules = {
    autoselect_one = false,
  },

  highlights = {
    enabled = true,
    statusline = {
      focused = {
        fg = mocha.text,
        bg = mocha.mauve,
      },
      unfocused = {
        fg = mocha.text,
        bg = mocha.mantle,
      },
    },
    winbar = {
      focused = {
        fg = mocha.text,
        bg = mocha.mauve,
      },
      unfocused = {
        fg = mocha.text,
        bg = mocha.mantle,
      },
    },
  },
}

vim.keymap.set('n', '<leader>w', function()
  local id = require('window-picker').pick_window()
  if id ~= nil then
    vim.fn.win_gotoid(id)
  end
end, { desc = 'goto window', })
