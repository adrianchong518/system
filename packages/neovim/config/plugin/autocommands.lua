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

-- Auto trim whitespaces
local trim_whitespace_group = api.nvim_create_augroup("trim_whitespace", { clear = true })
api.nvim_create_autocmd("InsertLeave", {
  group = trim_whitespace_group,
  callback = function()
    vim.cmd [[
      if &modifiable
        let saved_view = winsaveview()
        keepjumps '[,']s/\s\+$//e
        call winrestview(saved_view)
      endif
    ]]
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
