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
set.fillchars         = { eob = ' ', fold = ' ' }  -- no tildes past end of buffer, no fold dots
set.signcolumn        = 'number'      -- show diagnostic signs in the number column (no separate column)
set.numberwidth       = 4
set.foldcolumn        = '0'           -- no fold column; the bar rides in the status column
set.statuscolumn      = '%{%v:lua.StatusColumn()%}'

-- gutter -->
-- numbers right-aligned, then a fold cell adjacent to the text: the old
-- trailing gap now carries the marker, and is a plain space when there is no
-- fold. Replaces %l, so signcolumn='number' has to be honoured by hand.
local function fold_mark(lnum)
	if vim.fn.foldlevel(lnum) == 0 then return ' ' end
	if vim.fn.foldclosed(lnum) ~= -1 then return '%#FoldColumn#▸' end
	if lnum == 1 or vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
		return '%#FoldColumn#▾'
	end
	return '%#FoldColumn#│'
end

local function sign(lnum)
	local best
	local marks = vim.api.nvim_buf_get_extmarks(0, -1, { lnum - 1, 0 }, { lnum - 1, -1 },
		{ details = true, type = 'sign' })
	for _, mark in ipairs(marks) do
		local d = mark[4]
		if d.sign_text and (not best or (d.priority or 0) > (best.priority or 0)) then best = d end
	end
	if best then return ('%%#%s#%s'):format(best.sign_hl_group or 'SignColumn', best.sign_text) end
end

local function number(hl, n, cells)
	return ('%%#' .. hl .. '#%' .. cells .. 'd'):format(n)
end

StatusColumn = function()
	if vim.v.virtnum ~= 0 then return '' end
	local lnum, width = vim.v.lnum, vim.o.numberwidth
	local s = sign(lnum)
	if s then return ' ' .. s .. fold_mark(lnum) end
	local cursor = vim.v.relnum == 0
	local n = number(cursor and 'CursorLineNr' or 'LineNr', cursor and lnum or vim.v.relnum, width - 1)
	return n .. fold_mark(lnum)
end

-- ellipsis after a closed fold's text; foldtext='' leaves the row's own
-- syntax alone, so the marker has to be virtual text rather than a highlight
local ellipsis_ns = vim.api.nvim_create_namespace('fold_ellipsis')
vim.api.nvim_set_decoration_provider(ellipsis_ns, {
	on_line = function(_, _, buf, row)
		if vim.fn.foldclosed(row + 1) ~= row + 1 then return end
		vim.api.nvim_buf_set_extmark(buf, ellipsis_ns, row, 0, {
			virt_text = { { '…', 'FoldEllipsis' } },
			virt_text_pos = 'eol',
			ephemeral = true,
		})
	end,
})
-- <--
global.have_nerd_font = true
set.cmdheight         = 0             -- hide comandline when not in use
set.cmdwinheight      = 1
set.showmode          = false         -- don't show mode prompt (already in status line)
set.showcmd           = false         -- don't show partial command
set.shortmess         = 'ltToOCFscS'
require('vim._core.ui2').enable()     -- enable experimental ui mode
-- <--

-- editing -->
set.expandtab  = false
set.shiftwidth = 2
set.tabstop    = 2
-- <--

-- colorscheme -->
-- the 'ansi' colorscheme (colors/ansi.lua) is anchored to the terminal's 16 ANSI
-- colors, so termguicolors is OFF on purpose: cterm indices map straight onto the
-- terminal palette (colors/*.yaml), the single source of truth for colors.
vim.opt.termguicolors = false
vim.cmd.colorscheme('ansi')
-- <--

