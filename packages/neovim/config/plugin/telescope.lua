local telescope = require "telescope"
local actions = require "telescope.actions"
local actions_state = require("telescope.actions.state")
local builtin = require "telescope.builtin"
local wk = require "which-key"
local trouble = require("trouble.providers.telescope")

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

--- Grep the string under the cursor, filtering for the current file type
local function grep_string_current_file_type()
  grep_current_file_type(builtin.grep_string)
end

--- Live grep, filtering for the current file type
local function live_grep_current_file_type()
  grep_current_file_type(builtin.live_grep)
end

--- Like live_grep, but fuzzy (and slower)
local function fuzzy_grep(opts)
  opts = vim.tbl_extend("error", opts or {}, { search = "", prompt_title = "Fuzzy grep" })
  builtin.grep_string(opts)
end

local function fuzzy_grep_current_file_type()
  grep_current_file_type(fuzzy_grep)
end

local function open_in_oil(bufnr)
  local entry = actions_state.get_selected_entry()
  actions.close(bufnr)
  local folder_path = vim.fn.fnamemodify(entry.path, ":h")
  require("oil").open(folder_path)
end

wk.register({
    f = {
      name = "find",
      a = { function()
        builtin.find_files({ follow = true, no_ignore = true, no_ignore_parent = true, hidden = true })
      end, "[telescope] find files" },
      o = { builtin.oldfiles, "[telescope] old files" },
      w = { builtin.live_grep, "[telescope] live grep" },
      W = { fuzzy_grep, "[telescope] fuzzy grep" },
      g = { live_grep_current_file_type, "[telescope] live grep filetype" },
      G = { fuzzy_grep_current_file_type, "[telescope] fuzzy grep filetype" },
      f = { builtin.find_files, "[telescope] project files" },
      c = { builtin.quickfix, "[telescope] quickfix list" },
      q = { builtin.command_history, "[telescope] command history" },
      l = { builtin.loclist, "[telescope] loclist" },
      r = { builtin.registers, "[telescope] registers" },
      h = { builtin.help_tags, "[telescope] help" },
      m = { builtin.man_pages, "[telescope] man pages" },
      k = { builtin.keymaps, "[telescope] keymap" },
      e = { "<CMD>Telescope file_browser<CR>", "[telescope] file browser" },
      E = { "<CMD>Telescope file_browser path=%:p:h select_buffer=true<CR>", "[telescope] file browser (current buffer)" },
      t = { "<CMD>TodoTelescope<CR>", "[todo comments] open in telescope" },
    },
    b = {
      b = { builtin.buffers, "[telescope] buffers" },
      f = { builtin.current_buffer_fuzzy_find, "[telescope] fuzzy find (current buffer)" },
    },
  },
  { prefix = "<leader>" })

vim.keymap.set("n", "<leader>f*", grep_string_current_file_type, { desc = "[telescope] grep string filetype" })
vim.keymap.set("n", "<leader>*", builtin.grep_string, { desc = "[telescope] grep string" })

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
        ["<C-t>"] = trouble.open_with_trouble,
        ["<C-o>"] = open_in_oil,
      },
      n = {
        q = actions.close,
        ["<C-t>"] = trouble.open_with_trouble,
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
