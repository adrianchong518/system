local trouble = require "trouble"

trouble.setup {
  auto_jump = true,
  focus = true,

  win = {
    type = "split",
    relative = "win",
    size = 0.3,
    position = "bottom",
  },
}

require("which-key").add({
  { "<leader>x",  group = "trouble" },
  { "<leader>xx", function() trouble.toggle() end,                                      desc = "[trouble] toggle" },
  { "<leader>xq", function() trouble.toggle("quickfix") end,                            desc = "[trouble] toggle quickfix" },
  { "<leader>xl", function() trouble.toggle("loclist") end,                             desc = "[trouble] toggle loclist" },
  { "<leader>xn", function() trouble.next({ skip_groups = true, jump = true }) end,     desc = "[trouble] next" },
  { "<leader>xp", function() trouble.previous({ skip_groups = true, jump = true }) end, desc = "[trouble] previous" },
  { "<leader>xN", function() trouble.first({ skip_groups = true, jump = true }) end,    desc = "[trouble] first" },
  { "<leader>xP", function() trouble.last({ skip_groups = true, jump = true }) end,     desc = "[trouble] last" },
})
