local M = {}

M.setup = function()
  lvim.builtin.treesitter.auto_install = true
  lvim.builtin.treesitter.ensure_installed = { "comment", "markdown_inline", "regex" }
  lvim.builtin.treesitter.highlight.additional_vim_regex_highlighting = { "markdown" }

  lvim.builtin.treesitter.on_config_done = function(_)
    local status_ok, treesitter_install = pcall(require, "nvim-treesitter.install")
    if not status_ok then
      return
    end
  end
end

return M
