vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.softtabstop = 4

vim.o.relativenumber = true

vim.o.scrolloff = 5

vim.o.modeline = false

vim.g.editorconfig = true

vim.cmd [[
  packadd cfilter

  set fo=jn/croql

  set errorformat^=%-Gg%\\?make[%*\\d]:\ ***\ [%f:%l:%m
  set errorformat^=%-Gg%\\?make:\ ***\ [%f:%l:%m
]]
