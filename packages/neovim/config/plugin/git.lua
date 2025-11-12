local gitsigns = require 'gitsigns'
gitsigns.setup {
  on_attach = function()
    vim.keymap.set('n', '<leader>gb', gitsigns.blame_line, { desc = 'blame line', })
  end,
}

local neogit = require 'neogit'
neogit.setup {
  graph_style = 'kitty',
  integrations = { mini_pick = true, },
}

require('user').add_mini_clue { mode = 'n', keys = '<leader>g', desc = '+git', }
vim.keymap.set('n', '<leader>go', neogit.open, { desc = 'neogit', })
vim.keymap.set('n', '<leader>gO', function() neogit.open { cwd = '%:p:h', } end, { desc = 'neogit(cwd)', })
