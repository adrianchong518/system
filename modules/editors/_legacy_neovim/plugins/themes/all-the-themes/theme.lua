if vim.fn.empty "$TMUX" then
  if vim.fn.has "nvim" then
    vim.cmd "let $NVIM_TUI_ENABLE_TRUE_COLOR=1"
  end
end

vim.cmd [[
  syntax enable
  colorscheme ayu
]]
