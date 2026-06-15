local set = vim.opt
local global = vim.g

-- general -->
vim.g.mapleader      = ' '
vim.g.maplocalleader = ' '
set.swapfile         = false
vim.schedule(function()
	set.clipboard = 'unnamedplus' -- sync neovim and system clipboards
end)
-- <--

-- ui -->
set.number            = true          -- enable line numbers
set.relativenumber    = true          -- enable line numbers
set.linebreak         = true          -- wrap lines automatically
set.breakindent       = true          -- maintain indentation level of wrapped lines
set.cursorline        = true          -- highlight the line the cursor is one
set.scrolloff         = 20            -- maintain 20 lines above and below the cursor
set.splitbelow        = true          -- split new buffers below existing one
set.splitright        = true          -- vsplit new buffers to the right of existing one
set.smoothscroll      = true          -- enable smoothscrolling
set.fillchars         = { eob = ' '}  -- eliminate tildes after end of buffer
set.signcolumn        = 'number'      -- show diagnostic signs in the number column (no separate column)
global.have_nerd_font = true
set.cmdheight         = 0             -- hide comandline when not in use
set.cmdwinheight      = 1
set.showmode          = false         -- don't show mode prompt (already in status line)
set.showcmd           = false         -- don't show partial command
set.shortmess         = 'ltToOCFscS'
set.winborder         = "rounded"
require('vim._core.ui2').enable()     -- enable experimental ui mode
-- <--

-- editing -->
set.expandtab  = false
set.shiftwidth = 2
set.tabstop    = 2
-- <--

-- colorscheme -->
-- the 'light' colorscheme (colors/light.lua) is anchored to the terminal's 16 ANSI
-- colors, so termguicolors is OFF on purpose: cterm indices map straight onto the
-- iterm edge-light palette, the single source of truth for colors.
vim.opt.termguicolors = false
vim.cmd.colorscheme('light')
-- <--

