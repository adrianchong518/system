local miniclue = require('mini.clue')
miniclue.setup({
  window = {
    delay = 500,
    config = { width = 'auto', },
  },

  triggers = {
    { mode = 'n', keys = '<Leader>', },
    { mode = 'x', keys = '<Leader>', },

    { mode = 'i', keys = '<C-x>', },

    { mode = 'n', keys = 'g', },
    { mode = 'x', keys = 'g', },

    { mode = 'n', keys = "'", },
    { mode = 'n', keys = '`', },
    { mode = 'x', keys = "'", },
    { mode = 'x', keys = '`', },

    { mode = 'n', keys = '"', },
    { mode = 'x', keys = '"', },
    { mode = 'i', keys = '<C-r>', },
    { mode = 'c', keys = '<C-r>', },

    { mode = 'n', keys = '<C-w>', },

    { mode = 'n', keys = 'z', },
    { mode = 'x', keys = 'z', },
  },

  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),

    { mode = 'n', keys = '<localleader>', desc = '+local', },
  },
})

local minipick = require 'mini.pick'
require('user').add_mini_clue { mode = 'n', keys = '<leader>f', desc = '+find', }
vim.keymap.set('n', '<leader>fp', minipick.builtin.resume, { desc = 'resume', })
vim.keymap.set('n', '<leader>ff', minipick.builtin.files, { desc = 'files', })
vim.keymap.set('n', '<leader>fh', minipick.builtin.help, { desc = 'help', })
vim.keymap.set('n', '<leader>fw', minipick.builtin.grep_live, { desc = 'live grep', })
vim.keymap.set('n', '<leader>fg', function()
  minipick.builtin.grep({ pattern = vim.fn.expand '<cword>', })
end, { desc = 'grep under cursor', })
vim.keymap.set('n', '<leader>fc', require('mini.extra').pickers.commands, { desc = 'commands', })
vim.keymap.set('n', '<leader>fk', require('mini.extra').pickers.keymaps, { desc = 'keymaps', })

vim.keymap.set('n', '<esc><esc>', vim.cmd.nohlsearch)
