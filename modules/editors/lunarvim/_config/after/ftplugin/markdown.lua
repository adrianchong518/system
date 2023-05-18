-- Add the key mappings only for Markdown files in a zk notebook.
if require("zk.util").notebook_root(vim.fn.expand "%:p") ~= nil then
  require("which-key").register({
    -- This overrides the global `<leader>nn` mapping to create the note in the same directory as the current buffer.
    n = { "<cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<cr>", "New Note" },
    b = { "<cmd>ZkBacklinks<cr>", "Backlinks" },
    l = { "<cmd>ZkLinks<cr>", "Links" },
  }, { buffer = 0, prefix = "<leader>n" })

  require("which-key").register({
    ["nt"] = { ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<cr>", "New Note with Title" },
    ["nc"] = {
      ":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<cr>",
      "New Note with Content",
    },
  }, { buffer = 0, mode = "v", prefix = "<leader>n" })
end
