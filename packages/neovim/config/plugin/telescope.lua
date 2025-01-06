local telescope = require "telescope"
local actions = require "telescope.actions"
local actions_state = require("telescope.actions.state")
local builtin = require "telescope.builtin"
local wk = require "which-key"
local trouble = require("trouble.sources.telescope")

local layout_config = {
  horizontal = {
    prompt_position = "top",
    preview_width = 0.55,
    results_width = 0.8,
  },
  vertical = {
    mirror = false,
  },
  width = 0.87,
  height = 0.80,
  preview_cutoff = 120,
}

---@param picker function the telescope picker to use
local function grep_current_file_type(picker)
  local current_file_ext = vim.fn.expand "%:e"
  local additional_vimgrep_arguments = {}
  if current_file_ext ~= "" then
    additional_vimgrep_arguments = {
      "--type",
      current_file_ext,
    }
  end
  local conf = require("telescope.config").values
  picker {
    vimgrep_arguments = vim.tbl_flatten {
      conf.vimgrep_arguments,
      additional_vimgrep_arguments,
    },
  }
end

--- Like live_grep, but fuzzy (and slower)
local function fuzzy_grep(opts)
  opts = vim.tbl_extend("error", opts or {}, { search = "", prompt_title = "Fuzzy grep" })
  builtin.grep_string(opts)
end

local function open_in_oil(bufnr)
  local entry = actions_state.get_selected_entry()
  actions.close(bufnr)
  local folder_path = vim.fn.fnamemodify(entry.path, ":h")
  require("oil").open(folder_path)
end

wk.add({
  { "<leader>f",  group = "find" },
  {
    "<leader>fa",
    function()
      builtin.find_files({ follow = true, no_ignore = true, no_ignore_parent = true, hidden = true })
    end,
    desc = "[telescope] find files"
  },
  { "<leader>fo", builtin.oldfiles,                                                desc = "[telescope] old files" },
  { "<leader>fw", builtin.live_grep,                                               desc = "[telescope] live grep" },
  { "<leader>fW", fuzzy_grep,                                                      desc = "[telescope] fuzzy grep" },
  { "<leader>fg", builtin.grep_string,                                             desc = "[telescope] grep string under cursor" },
  { "<leader>ff", builtin.find_files,                                              desc = "[telescope] project files" },
  { "<leader>fc", builtin.quickfix,                                                desc = "[telescope] quickfix list" },
  { "<leader>fq", builtin.command_history,                                         desc = "[telescope] command history" },
  { "<leader>fl", builtin.loclist,                                                 desc = "[telescope] loclist" },
  { "<leader>fr", builtin.registers,                                               desc = "[telescope] registers" },
  { "<leader>fh", builtin.help_tags,                                               desc = "[telescope] help" },
  { "<leader>fm", builtin.man_pages,                                               desc = "[telescope] man pages" },
  { "<leader>fk", builtin.keymaps,                                                 desc = "[telescope] keymap" },
  { "<leader>fe", "<CMD>Telescope file_browser<CR>",                               desc = "[telescope] file browser" },
  { "<leader>fE", "<CMD>Telescope file_browser path=%:p:h select_buffer=true<CR>", desc = "[telescope] file browser (current buffer)" },
  { "<leader>ft", "<CMD>TodoTelescope<CR>",                                        desc = "[todo comments] open in telescope" },

  { "<leader>bb", builtin.buffers,                                                 desc = "[telescope] buffers" },
  { "<leader>bf", builtin.current_buffer_fuzzy_find,                               desc = "[telescope] fuzzy find (current buffer)" },
})

telescope.setup {
  defaults = {
    path_display = {
      "truncate",
    },
    layout_strategy = "horizontal",
    layout_config = layout_config,
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<C-s>"] = actions.file_split,
        ["<C-t>"] = trouble.open,
        ["<C-o>"] = open_in_oil,
      },
      n = {
        q = actions.close,
        ["<C-t>"] = trouble.open,
        o = open_in_oil,
      },
    },
    preview = {
      treesitter = true,
    },
    history = {
      path = vim.fn.stdpath "data" .. "/telescope_history.sqlite3",
      limit = 1000,
    },
    color_devicons = true,
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    set_env = { ["COLORTERM"] = "truecolor" },
    prompt_prefix = "   ",
    selection_caret = "  ",
    entry_prefix = "  ",
    initial_mode = "insert",
    vimgrep_arguments = {
      "rg",
      "-L",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
    },
  },
  extensions = {
    fzy_native = {
      override_generic_sorter = false,
      override_file_sorter = true,
    },
    file_browser = {
      grouped = true,
    },
  },
}

telescope.load_extension "fzy_native"
telescope.load_extension "file_browser"
