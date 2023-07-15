local function render(props)
  local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":p:.")
  local ft_icon, ft_color = require("nvim-web-devicons").get_icon_color(filepath)
  local modified = vim.api.nvim_buf_get_option(props.buf, "modified") and "bold,italic" or "bold"

  local buffer = {
    { ft_icon,                         guifg = ft_color },
    { " " },
    { vim.fn.pathshorten(filepath, 3), gui = modified },
  }
  return buffer
end

require("incline").setup {
  render = render,
}
