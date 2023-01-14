--- General Vim Settings ----------
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.encoding = 'utf-8'
vim.o.wildmenu = true
vim.o.lazyredraw = true
vim.o.ruler = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.mouse = 'a'
vim.o.scrolloff = 5
vim.o.cursorline = true
vim.o.updatetime = 300
vim.o.signcolumn = 'yes'

vim.cmd([[
    set nobackup
    set nowritebackup
]])

-- Strip trailing whitespaces
function vim.fn.stripTrailingWhitespace()
    local l = vim.fn.line('.')
    local c = vim.fn.col('.')
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.cursor({l, c})
end
vim.cmd('autocmd BufWritePre * :lua vim.fn.stripTrailingWhitespace()')

-- Set indentation
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true

local function setTabWidth(filetype, width)
    vim.cmd(string.format('autocmd FileType %s setlocal shiftwidth=%d softtabstop=%d expandtab', filetype, width, width))
end

setTabWidth('nix', 2)
setTabWidth('c', 2)
setTabWidth('cpp', 2)
setTabWidth('scheme', 2)
setTabWidth('haskell', 2)
setTabWidth('markdown', 2)

-- Set textwidth etc.
vim.o.colorcolumn = '+1'
vim.o.formatoptions = 'tcqjn'

local function setTextWidth(filetype, tw)
    vim.cmd(string.format('autocmd FileType %s setlocal textwidth=%d', filetype, tw))
    -- vim.cmd(string.format('autocmd FileType %s highlight OverLength ctermbg=darkgrey guibg=#592929', filetype))
    -- vim.cmd(string.format('autocmd FileType %s match OverLength /\\%%%dv.*/', filetype, tw+1))
end

setTextWidth('c', 80)
setTextWidth('cpp', 80)
setTextWidth('rust', 120)

