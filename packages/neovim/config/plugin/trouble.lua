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

require("which-key").register({
  name = "trouble",
  x = { function() trouble.toggle() end, "[trouble] toggle" },
  q = { function() trouble.toggle("quickfix") end, "[trouble] toggle quickfix" },
  l = { function() trouble.toggle("loclist") end, "[trouble] toggle loclist" },
  n = { function() trouble.next({ skip_groups = true, jump = true }) end, "[trouble] next" },
  p = { function() trouble.previous({ skip_groups = true, jump = true }) end, "[trouble] previous" },
  N = { function() trouble.first({ skip_groups = true, jump = true }) end, "[trouble] first" },
  P = { function() trouble.last({ skip_groups = true, jump = true }) end, "[trouble] last" },
}, { prefix = "<leader>x" })
