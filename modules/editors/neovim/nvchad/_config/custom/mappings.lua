local M = {}

M.disabled = {
  n = {
    ["<tab>"] = {},
    ["<S-tab>"] = {},
    ["<leader>x"] = {},
    ["<leader>/"] = {},
    ["<leader>n"] = {},
    ["<leader>rn"] = {},
    ["<leader>fh"] = {},
    ["<leader>th"] = {},
    ["<leader>h"] = {},
    ["<leader>v"] = {},
    ["<leader>D"] = {},
    ["<leader>ra"] = {},
    ["<leader>ca"] = {},
    ["<leader>f"] = {},
    ["<leader>q"] = {},
    ["<leader>pt"] = {},
    ["<leader>ma"] = {},
    ["<leader>cm"] = {},
    ["<leader>rh"] = {},
    ["<leader>ph"] = {},
    ["<leader>td"] = {},
    ["<C-c>"] = {},
  },
  v = {
    ["<leader>/"] = {},
  },
}

M.navigation = {
  n = {
    ["<C-h>"] = { "<cmd>NavigatorLeft<CR>", "Navigate left" },
    ["<C-l>"] = { "<cmd>NavigatorRight<CR>", "Navigate right" },
    ["<C-j>"] = { "<cmd>NavigatorDown<CR>", "Navigate down" },
    ["<C-k>"] = { "<cmd>NavigatorUp<CR>", "Navigate up" },
  },
}

M.help = {
  n = {
    ["<leader>hh"] = { "<cmd> Telescope help_tags <CR>", "Help page" },
    ["<leader>hc"] = { "<cmd> NvCheatsheet <CR>", "Mapping cheatsheet" },
    ["<leader>ht"] = { "<cmd> Telescope themes <CR>", "Nvchad themes" },
    ["<leader>hm"] = { "<cmd> Telescope man_pages <CR>", "Man pages" },
    ["<leader>hk"] = { "<cmd> Telescope keymaps <CR>", "Keymap" },
  },
}

M["treesitter-context"] = {
  n = {
    ["<leader>cc"] = {
      function()
        local status_ok, tc = pcall(require, "treesitter-context")
        if not status_ok then
          return
        end
        tc.go_to_context()
      end,
      "Jump to context",
    },
  },
}

M.lspconfig = {
  n = {
    ["gt"] = { "<cmd> Telescope lsp_type_definitions <cr>", "LSP type definition" },
    ["gr"] = { "<cmd> Telescope lsp_references <cr>", "LSP references" },
    ["gd"] = { "<cmd> Telescope lsp_definitions <cr>", "LSP definitions" },

    ["<leader>lr"] = {
      function()
        require("nvchad.renamer").open()
      end,
      "LSP rename",
    },

    ["<leader>la"] = {
      function()
        vim.lsp.buf.code_action()
      end,
      "LSP code action",
    },

    ["<leader>lf"] = {
      function()
        vim.diagnostic.open_float { border = "rounded" }
      end,
      "Floating diagnostic",
    },

    ["<leader>ld"] = { "<cmd> Telescope diagnostics <cr>", "Diagnostic setloclist" },

    ["<leader>lh"] = {
      function()
        vim.lsp.buf.signature_help()
      end,
      "LSP signature help",
    },

    ["<leader>lS"] = { "<cmd> Telescope lsp_dynamic_workspace_symbols <CR>", "LSP workspace symbols" },
    ["<leader>ls"] = { "<cmd> Telescope lsp_document_symbols <CR>", "LSP document symbols" },
  },
}

M.telescope = {
  n = {
    ["<leader>tp"] = { "<cmd> Telescope terms <CR>", "Pick hidden term" },
    ["<leader>fm"] = { "<cmd> Telescope marks <CR>", "telescope bookmarks" },
    ["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "Git commits" },
  },
}

M.neogit = {
  n = {
    ["<leader>gg"] = { "<cmd>Neogit<cr>", "Open neogit" },
  },
}

M.gitsigns = {
  n = {
    ["<leader>gr"] = {
      function()
        require("gitsigns").reset_hunk()
      end,
      "Reset hunk",
    },

    ["<leader>gp"] = {
      function()
        require("gitsigns").preview_hunk()
      end,
      "Preview hunk",
    },

    ["<leader>gtd"] = {
      function()
        require("gitsigns").toggle_deleted()
      end,
      "Toggle deleted",
    },
  },
}

M.zk = {
  n = {
    ["<leader>nn"] = { "<cmd>ZkNew { title = vim.fn.input('Title: ') }<cr>", "New Note" },
    ["<leader>no"] = { "<cmd>ZkNotes { sort = { 'modified' } }<cr>", "Open Note" },
    ["<leader>nt"] = { "<cmd>ZkTags<cr>", "Open Note with Tag" },
    ["<leader>nf"] = {
      "<cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<cr>",
      "Search Notes",
    },
  },
  v = {
    ["<leader>nf"] = { ":'<,'>ZkMatch<cr>", "Search selection in Notes" },
  },
}

return M
