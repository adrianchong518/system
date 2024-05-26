local cmd = vim.cmd
local fn = vim.fn
local opt = vim.o
local g = vim.g

-- <leader> key. Defaults to `\`. Some people prefer space.
g.mapleader = " "
g.maplocalleader = " "

opt.compatible = false

-- Enable true colour support
if fn.has "termguicolors" then
  opt.termguicolors = true
end

-- See :h <option> to see what the options do

-- Search down into subfolders
opt.path = vim.o.path .. "**"

opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.showmatch = false
opt.incsearch = true
opt.hlsearch = true

opt.modeline = false

opt.expandtab = true
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.history = 2000
opt.nrformats = "bin,hex" -- 'octal'
opt.undofile = true
opt.splitright = true
opt.splitbelow = true
opt.cmdheight = 0
opt.scrolloff = 5

opt.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

opt.foldcolumn = "1"
opt.foldlevel = 99      -- huge number for ufo.nvim
opt.foldlevelstart = 99 -- huge number for ufo.nvim
opt.foldenable = true

-- Configure Neovim diagnostic messages

local function prefix_diagnostic(prefix, diagnostic)
  return string.format(prefix .. " %s", diagnostic.message)
end

local sign = function(opts)
  fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = "",
  })
end
-- Requires Nerd fonts
sign { name = "DiagnosticSignError", text = "󰅚" }
sign { name = "DiagnosticSignWarn", text = "⚠" }
sign { name = "DiagnosticSignInfo", text = "ⓘ" }
sign { name = "DiagnosticSignHint", text = "󰌶" }

vim.diagnostic.config {
  virtual_text = {
    prefix = "",
    format = function(diagnostic)
      local severity = diagnostic.severity
      if severity == vim.diagnostic.severity.ERROR then
        return prefix_diagnostic("󰅚", diagnostic)
      end
      if severity == vim.diagnostic.severity.WARN then
        return prefix_diagnostic("⚠", diagnostic)
      end
      if severity == vim.diagnostic.severity.INFO then
        return prefix_diagnostic("ⓘ", diagnostic)
      end
      if severity == vim.diagnostic.severity.HINT then
        return prefix_diagnostic("󰌶", diagnostic)
      end
      return prefix_diagnostic("■", diagnostic)
    end,
  },
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
}

g.editorconfig = true

-- Native plugins
cmd.filetype("plugin", "indent", "on")
cmd.packadd "cfilter" -- Allows filtering the quickfix list with :cfdo

-- let sqlite.lua (which some plugins depend on) know where to find sqlite
vim.g.sqlite_clib_path = require("luv").os_getenv "LIBSQLITE"

-- this should be at the end, because
-- it causes neovim to source ftplugins
-- on the packpath when passing a file to the nvim command
cmd.syntax "on"
cmd.syntax "enable"

-- Set catppuccin theme
cmd.colorscheme "catppuccin"

cmd.set "fo=jn/croql"
cmd.set [[errorformat^=%-Gg%\\?make[%*\\d]:\ ***\ [%f:%l:%m]]
cmd.set [[errorformat^=%-Gg%\\?make:\ ***\ [%f:%l:%m]]
