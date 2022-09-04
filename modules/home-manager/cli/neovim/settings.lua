-- General Vim settings
vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = true
vim.o.encoding = "utf-8"
vim.o.wildmenu = true
vim.o.lazyredraw = true
vim.o.ruler = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.softtabstop = 4
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.incsearch = true
vim.o.hlsearch = true
vim.o.mouse = "a"
vim.o.scrolloff = 5

function vim.fn.stripTrailingWhitespace()
    local l = vim.fn.line(".")
    local c = vim.fn.col(".")
    vim.cmd("%s/\\s\\+$//e")
    vim.fn.cursor(l, c)
end

-- strip all files by default
vim.cmd("autocmd BufWritePre * :lua vim.fn.stripTrailingWhitespace()")