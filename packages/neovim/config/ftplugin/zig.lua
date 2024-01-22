vim.cmd.setlocal("colorcolumn=101")

if vim.fn.executable "zls" ~= 1 then
  return
end

local root_files = {
  "zls.json",
  "build.zig",
  "build.zig.zon",
  ".git",
}

vim.lsp.start {
  name = "zls",
  cmd = { "zls" },
  root_dir = vim.fs.dirname(vim.fs.find(root_files, { upward = true })[1]),
  capabilities = require("user.lsp").make_client_capabilities(),
}
