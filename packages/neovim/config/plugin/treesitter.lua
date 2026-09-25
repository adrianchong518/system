local ts_group = vim.api.nvim_create_augroup('treesitter', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function(ev)
    local ft = ev.match

    local lang = vim.treesitter.language.get_lang(ft)
    if not lang then
      return
    end

    if vim.treesitter.language.add(lang) then
      vim.treesitter.start(ev.buf, lang)
    end
  end,
  group = ts_group,
})
