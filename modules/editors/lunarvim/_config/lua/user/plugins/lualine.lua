local M = {}

M.setup = function()
  lvim.builtin.lualine.sections.lualine_c = {
    { "filename", newfile_status = true, path = 1 },
  }
end

return M
