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

		vim.api.nvim_set_hl(0, 'NormalFloat', { link = 'Normal' })
		vim.api.nvim_set_hl(0, 'FloatBorder', { bg = none, fg = '#8790a0' })
		vim.api.nvim_set_hl(0, 'FloatTitle', { bg = none, fg = '#76af6f', bold = true })

		vim.api.nvim_set_hl(0, 'MiniPickBorderText', { bg = none, fg = '#76af6f', bold = true, italic = true })
		vim.api.nvim_set_hl(0, 'MiniPickPrompt', { link = 'Normal' })
		vim.api.nvim_set_hl(0, 'MiniPickNormal', { fg = '#8790a0' })
		vim.api.nvim_set_hl(0, 'MiniPickMatchRanges', { fg = '#608e32', bold = true })

		vim.api.nvim_set_hl(0, 'Folded', { fg = '#8790a0', bg = '#dde2e7', bold = true })
	end
})
-- <-

-- enable incsearch for cmd-window ->
-- autocmd('CmdwinEnter', {
-- 	group = vim.api.nvim_create_augroup('cmdwin_highlight', {}),
-- 	pattern = {'/', '?'},
-- 	callback = function()
-- 		vim.cmd [[ let @/ = getline('.') |
-- 		\ autocmd TextChangedI,TextChangedP
-- 		\ <buffer> let @/ = getline('.') ]]
-- 	end
-- })
-- <-
