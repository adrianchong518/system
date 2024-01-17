local M = {}

M.setup = function()
  lvim.builtin.nvimtree.setup.view.side = "left"
  lvim.builtin.nvimtree.setup.view.width = 40

  lvim.builtin.nvimtree.setup.renderer.icons.show.git = true
  lvim.builtin.nvimtree.setup.renderer.group_empty = true
  lvim.builtin.nvimtree.setup.renderer.indent_markers.enable = true
end

return M
