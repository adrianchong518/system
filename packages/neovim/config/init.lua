vim.cmd.colorscheme 'catppuccin'

vim.g.mapleader = ' '
vim.g.maplocalleader = '  '

vim.o.path = vim.o.path .. '**'

vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 2
vim.o.signcolumn = 'yes'

vim.o.cursorline = true

vim.o.scrolloff = 5

vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.modeline = false

vim.o.splitright = true
vim.o.splitbelow = true

vim.cmd.filetype('plugin', 'indent', 'on')
vim.o.formatoptions = 'jn/croql'

vim.g.editorconfig = true
vim.o.exrc = true

vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.shiftwidth = 4

vim.o.undofile = true

vim.o.fileencodings = 'ucs-bom,utf-8,default,euc-jp,euc-cn,euc-tw,latin1'

vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.listchars = 'tab:▸ ,space:∘,trail:•,extends:>,precedes:<,nbsp:%,eol:⤶'
vim.o.list = true

vim.cmd.packadd 'cfilter' -- Allows filtering the quickfix list with :cfdo
vim.cmd.set [[errorformat^=%-Gg%\\?make[%*\\d]:\ ***\ [%f:%l:%m]]
vim.cmd.set [[errorformat^=%-Gg%\\?make:\ ***\ [%f:%l:%m]]

vim.filetype.add {
  extension = {
    repos = 'yaml',
  },
}
