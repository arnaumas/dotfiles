local autocmd = vim.api.nvim_create_autocmd

-- highlight yanked text -->
autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
-- <--

-- enable incsearch for cmd-window -->
-- autocmd('CmdwinEnter', {
-- 	group = vim.api.nvim_create_augroup('cmdwin_highlight', {}),
-- 	pattern = {'/', '?'},
-- 	callback = function()
-- 		vim.cmd [[ let @/ = getline('.') |
-- 		\ autocmd TextChangedI,TextChangedP
-- 		\ <buffer> let @/ = getline('.') ]]
-- 	end
-- })
-- <--

-- restore cursor after exiting vim -->
autocmd('VimLeave', {
	desc = 'Restore cursor to pipe after exiting neovim',
	group = vim.api.nvim_create_augroup('restore_cursor', {clear = true}),
	pattern = '*',
	callback = function()
		os.execute [[ echo -ne "\e[6 q" ]]
	end
})
-- <--
