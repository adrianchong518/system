local neogit = require 'neogit'
neogit.setup {
  graph_style = 'kitty',
  integrations = { mini_pick = true, },
}

require('mini.diff').setup {}

local minigit = require('mini.git')
minigit.setup {}

local align_blame = function(au_data)
  if au_data.data.git_subcommand ~= 'blame' then return end

  -- Align blame output with source
  local win_src = au_data.data.win_source
  vim.wo.wrap = false
  vim.fn.winrestview({ topline = vim.fn.line('w0', win_src), })
  vim.api.nvim_win_set_cursor(0, { vim.fn.line('.', win_src), 0, })

  -- Bind both windows so that they scroll together
  vim.wo[win_src].scrollbind, vim.wo.scrollbind = true, true
end

local au_opts = { pattern = 'MiniGitCommandSplit', callback = align_blame, }
vim.api.nvim_create_autocmd('User', au_opts)

require('user').add_mini_clue { mode = 'n', keys = '<leader>g', desc = '+git', }
vim.keymap.set('n', '<leader>go', neogit.open, { desc = 'neogit', })
vim.keymap.set('n', '<leader>gO', function() neogit.open { cwd = '%:p:h', } end, { desc = 'neogit(cwd)', })
vim.keymap.set({ 'n', 'x', }, '<Leader>gs', minigit.show_at_cursor, { desc = 'show at cursor', })
vim.keymap.set('n', '<Leader>gb', '<cmd>vert Git blame -- %<cr>', { desc = 'blame', })
