local set = vim.opt
local global = vim.g
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- general ->
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '
vim.schedule(function()
	set.clipboard = 'unnamedplus' -- sync neovim and system clipboards
end)
-- <-

-- ui ->
set.number            = true          -- enable line numbers
set.linebreak         = true          -- wrap lines automatically
set.breakindent       = true          -- maintain indentation level of wrapped lines
set.cursorline        = true          -- highlight the line the cursor is one
set.scrolloff         = 20            -- maintain 20 lines above and below the cursor
set.splitbelow        = true          -- split new buffers below existing one
set.splitright        = true          -- vsplit new buffers to the right of existing one
set.smoothscroll      = true          -- enable smoothscrolling
set.fillchars         = { eob = ' '}  -- eliminate tildes after end of buffer
global.have_nerd_font = true
-- <-

-- editing ->
set.expandtab  = false
set.shiftwidth = 2
set.tabstop    = 2
-- <-

-- colorscheme ->
global.edge_transparent_background = 1
global.edge_enable_italic = true
later(function() vim.cmd.colorscheme('edge') end)
-- <-

-- statusline ->
later(function() 
	local statusline = require('mini.statusline')
	statusline.setup()
	statusline.section_location = function() return '%2l:%-2v' end
end)
-- <-
