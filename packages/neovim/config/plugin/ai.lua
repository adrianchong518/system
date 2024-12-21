require("copilot").setup {
  suggestion = { enabled = false },
  panel = { enabled = false },
}
require("copilot_cmp").setup()

require("codecompanion").setup {
  display = {
    chat = {
      show_settings = true,
    }
  },
  strategies = {
    chat = {
      adapter = "copilot",
    },
    inline = {
      adapter = "copilot",
    },
    agent = {
      adapter = "copilot",
    },
  },
  -- adapters = {
  --   copilot = function()
  --     return require("codecompanion.adapters").extend("copilot", {
  --       schema = {
  --         model = {
  --           default = "claude-3.5-sonnet",
  --         },
  --       },
  --     })
  --   end,
  -- },
}
