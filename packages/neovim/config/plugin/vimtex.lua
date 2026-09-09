vim.g.vimtex_view_method = 'zathura'
-- vim.g.vimtex_syntax_enabled = 0

vim.g.vimtex_callback_progpath = vim.fn.exepath(vim.v.progname)

vim.g.vimtex_compiler_latexmk = {
  ['out_dir'] = 'build',
}

vim.g.vimtex_quickfix_ignore_filters = {
  'Token not allowed in a PDF string',
}

vim.g.vimtex_quickfix_autoclose_after_keystrokes = 1
