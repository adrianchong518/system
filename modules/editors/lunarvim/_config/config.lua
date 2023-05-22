vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.relativenumber = true
vim.opt.showtabline = 1
vim.opt.wrap = true

lvim.log.level = "info"
lvim.format_on_save.enabled = true

lvim.builtin.alpha.active = true
lvim.builtin.terminal.active = true
lvim.builtin.bufferline.active = false

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

require("user").setup {
  winbar_provider = "filename",
  enabled_plugins = {
    fidget = true,
    zen_mode = true,
    telescope = { file_browser = true },
    crates = true,
    zk = true,
    surround = true,
  },
}
