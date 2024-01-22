local api = vim.api
local fn = vim.fn
local keymap = vim.keymap
local diagnostic = vim.diagnostic
local wk = require "which-key"

wk.register({
  b = { name = "buffer" },
  t = { name = "tab" },
  h = { name = "git hunk" },
  g = {
    name = "git",
    t = { name = "toggle", },
  },
  w = { name = "window" },
}, { prefix = "<leader>" })

-- Yank from current position till end of current line
keymap.set("n", "Y", "y$", { silent = true, desc = "yank to end of line" })

-- Buffer list navigation
keymap.set("n", "[b", vim.cmd.bprevious, { silent = true, desc = "previous buffer" })
keymap.set("n", "]b", vim.cmd.bnext, { silent = true, desc = "next buffer" })
keymap.set("n", "[B", vim.cmd.bfirst, { silent = true, desc = "first buffer" })
keymap.set("n", "]B", vim.cmd.blast, { silent = true, desc = "last buffer" })

-- Toggle the quickfix list (only opens if it is populated)
local function toggle_qf_list()
  local qf_exists = false
  for _, win in pairs(fn.getwininfo() or {}) do
    if win["quickfix"] == 1 then
      qf_exists = true
    end
  end
  if qf_exists == true then
    vim.cmd.cclose()
    return
  end
  if not vim.tbl_isempty(vim.fn.getqflist()) then
    vim.cmd.copen()
  end
end

keymap.set("n", "<C-c>", toggle_qf_list, { desc = "toggle quickfix list" })

local function try_fallback_notify(opts)
  local success, _ = pcall(opts.try)
  if success then
    return
  end
  success, _ = pcall(opts.fallback)
  if success then
    return
  end
  vim.notify(opts.notify, vim.log.levels.INFO)
end

-- Resize vertical splits
local toIntegral = math.ceil
keymap.set("n", "<leader>w+", function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 3 / 2))
end, { silent = true, desc = "inc window width" })
keymap.set("n", "<leader>w-", function()
  local curWinWidth = api.nvim_win_get_width(0)
  api.nvim_win_set_width(0, toIntegral(curWinWidth * 2 / 3))
end, { silent = true, desc = "dec window width" })
keymap.set("n", "<leader>h+", function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 3 / 2))
end, { silent = true, desc = "inc window height" })
keymap.set("n", "<leader>h-", function()
  local curWinHeight = api.nvim_win_get_height(0)
  api.nvim_win_set_height(0, toIntegral(curWinHeight * 2 / 3))
end, { silent = true, desc = "dec window height" })

-- Close floating windows [Neovim 0.10 and above]
keymap.set("n", "<leader>fq", function()
  vim.cmd "fclose!"
end, { silent = true, desc = "close all floating windows" })

-- Remap Esc to switch to normal mode and Ctrl-Esc to pass Esc to terminal
keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "switch to normal mode" })
keymap.set("t", "<C-Esc>", "<Esc>", { desc = "send Esc to terminal" })

-- Shortcut for expanding to current buffer's directory in command mode
keymap.set("c", "%%", function()
  if fn.getcmdtype() == ":" then
    return fn.expand "%:h" .. "/"
  else
    return "%%"
  end
end, { expr = true, desc = "expand to current buffer's directory" })

keymap.set("n", "<leader>tn", vim.cmd.tabnew, { desc = "new tab" })
keymap.set("n", "<leader>tq", vim.cmd.tabclose, { desc = "close tab" })

local severity = diagnostic.severity

keymap.set("n", "<leader>lf", function()
  local _, winid = diagnostic.open_float(nil, { scope = "line" })
  if not winid then
    vim.notify("no diagnostics found", vim.log.levels.INFO)
    return
  end
  vim.api.nvim_win_set_config(winid or 0, { focusable = true })
end, { noremap = true, silent = true, desc = "diagnostics floating window" })
keymap.set("n", "[d", diagnostic.goto_prev, { noremap = true, silent = true, desc = "previous diagnostic" })
keymap.set("n", "]d", diagnostic.goto_next, { noremap = true, silent = true, desc = "next diagnostic" })
keymap.set("n", "[e", function()
  diagnostic.goto_prev {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = "previous error diagnostic" })
keymap.set("n", "]e", function()
  diagnostic.goto_next {
    severity = severity.ERROR,
  }
end, { noremap = true, silent = true, desc = "next error diagnostic" })
keymap.set("n", "[w", function()
  diagnostic.goto_prev {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = "previous warning diagnostic" })
keymap.set("n", "]w", function()
  diagnostic.goto_next {
    severity = severity.WARN,
  }
end, { noremap = true, silent = true, desc = "next warning diagnostic" })
keymap.set("n", "[h", function()
  diagnostic.goto_prev {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = "previous hint diagnostic" })
keymap.set("n", "]h", function()
  diagnostic.goto_next {
    severity = severity.HINT,
  }
end, { noremap = true, silent = true, desc = "next hint diagnostic" })

local function toggle_spell_check()
  ---@diagnostic disable-next-line: param-type-mismatch
  vim.opt.spell = not (vim.opt.spell:get())
end

keymap.set("n", "<leader>S", toggle_spell_check, { noremap = true, silent = true, desc = "toggle spell" })

keymap.set("n", "<C-d>", "<C-d>zz", { desc = "move down half-page and center" })
keymap.set("n", "<C-u>", "<C-u>zz", { desc = "move up half-page and center" })
keymap.set("n", "<C-f>", "<C-f>zz", { desc = "move down full-page and center" })
keymap.set("n", "<C-b>", "<C-b>zz", { desc = "move up full-page and center" })

--- Disabled keymaps [enable at your own risk]

-- Automatic management of search highlight
-- XXX: This is not so nice if you use j/k for navigation
-- (you should be using <C-d>/<C-u> and relative line numbers instead ;)
--
-- local auto_hlsearch_namespace = vim.api.nvim_create_namespace('auto_hlsearch')
-- vim.on_key(function(char)
--   if vim.fn.mode() == 'n' then
--     vim.opt.hlsearch = vim.tbl_contains({ '<CR>', 'n', 'N', '*', '#', '?', '/' }, vim.fn.keytrans(char))
--   end
-- end, auto_hlsearch_namespace)
