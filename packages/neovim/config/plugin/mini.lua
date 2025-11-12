require('mini.extra').setup()
require('mini.icons').setup()
require('mini.ai').setup()
require('mini.align').setup()
require('mini.comment').setup()
require('mini.jump').setup()
require('mini.move').setup()
require('mini.pairs').setup()
require('mini.splitjoin').setup()
require('mini.trailspace').setup()

require('mini.indentscope').setup {
  draw = {
    delay = 0,
    animation = require('mini.indentscope').gen_animation.none(),
  },
}

require('mini.surround').setup {
  mappings = {
    add       = 'za',
    delete    = 'zd',
    find      = 'zf',
    find_left = 'zF',
    highlight = 'zh',
    replace   = 'zr',
  },
}

require('mini.pick').setup {
  mappings = {
    refine        = '<M-Space>',
    refine_marked = '<M-S-Space>',
  },
}

local hi_words = require('mini.extra').gen_highlighter.words
local hipatterns = require('mini.hipatterns')
hipatterns.setup {
  highlighters = {
    hex_color = hipatterns.gen_highlighter.hex_color(),
    fixme     = hi_words({ 'FIXME', 'BUG', }, 'MiniHipatternsFixme'),
    todo      = hi_words({ 'TODO', }, 'MiniHipatternsTodo'),
    note      = hi_words({ 'NOTE', }, 'MiniHipatternsNote'),
    hack      = hi_words({ 'HACK', 'XXX', }, 'MiniHipatternsHack'),
  },
}
