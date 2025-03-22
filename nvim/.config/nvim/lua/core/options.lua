local set = vim.opt

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

set.splitbelow = true -- split new buffers below existing one
set.splitright = true -- vsplit new buffers to the right of existing one

set.number = true -- enable line numbers
set.linebreak = true -- wrap lines automatically
set.breakindent = true -- maintain indentation level of wrapped lines
set.cursorline = true -- highlight the line the cursor is one
set.scrolloff = 20 -- maintain 20 lines above and below the cursor
set.smoothscroll = true -- enable smoothscrolling

vim.g.have_nerd_font = true

vim.schedule(function()
	set.clipboard = 'unnamedplus' -- sync neovim and system clipboards
end)
