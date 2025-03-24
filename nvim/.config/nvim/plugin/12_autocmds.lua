local autocmd = vim.api.nvim_create_autocmd

-- highlight yanked text ->
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- <-

-- overwrite edge highlights ->
autocmd('ColorScheme', {
	group = vim.api.nvim_create_augroup('custom_highlights_edge', {}),
	pattern = 'edge',
	callback = function()
		vim.api.nvim_set_hl(0, 'Visual', { link = 'IncSearch' })
		vim.api.nvim_set_hl(0, 'Folded', { fg = '#8790a0', bg = '#dde2e7', bold = true })
	end
})
-- <-
