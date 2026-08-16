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
set.signcolumn        = 'no'          -- StatusColumn draws signs manually, in the number field
set.foldcolumn        = '0'           -- no fold column; the marker rides in the status column
set.statuscolumn      = '%{%v:lua.StatusColumn()%}'

-- empty foldtext = pass-through: fold's first line renders with its own
-- treesitter highlights. The autocmd keeps plugins that set foldtext
-- window-locally (vimtex) from winning.
vim.opt.foldtext = ''
vim.api.nvim_create_autocmd({ 'FileType', 'BufWinEnter' }, {
	callback = function() vim.wo.foldtext = '' end,
})

-- gutter -->
-- <number field, sized to the buffer's line count><space><fold cell>. Signs
-- replace the number field, right-aligned to the same width.
local function fold_mark(lnum)
	if vim.fn.foldlevel(lnum) == 0 then return ' ' end
	if vim.fn.foldclosed(lnum) ~= -1 then return '%#FoldColumn#\u{F460}' end
	if lnum == 1 or vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
		return '%#FoldColumn#\u{F47C}'
	end
	return '%#FoldColumn#\u{23B9}'
end

local function sign(lnum)
	local best
	local marks = vim.api.nvim_buf_get_extmarks(0, -1, { lnum - 1, 0 }, { lnum - 1, -1 },
		{ details = true, type = 'sign' })
	for _, mark in ipairs(marks) do
		local d = mark[4]
		if d.sign_text and (not best or (d.priority or 0) > (best.priority or 0)) then best = d end
	end
	if best then return best.sign_text, best.sign_hl_group or 'SignColumn' end
end

local function number(hl, n, cells)
	return ('%%#' .. hl .. '#%' .. cells .. 'd'):format(n)
end

StatusColumn = function()
	local lnum = vim.v.lnum
	local width = #tostring(vim.api.nvim_buf_line_count(0))
	if vim.v.virtnum > 0 then
		local mark = vim.fn.foldlevel(lnum) > 0 and '%#FoldColumn#\u{23B9}' or ' '
		return string.rep(' ', width) .. mark .. ' '
	end
	if vim.v.virtnum < 0 then return '' end
	local text, hl = sign(lnum)
	if text then
		text = text:gsub('%s+$', '')
		local pad = width - vim.fn.strdisplaywidth(text)
		return ('%s%%#%s#%s%s '):format(pad > 0 and string.rep(' ', pad) or '', hl, text, fold_mark(lnum))
	end
	local cursor = vim.v.relnum == 0
	local n = cursor and lnum or vim.v.relnum
	return number(cursor and 'CursorLineNr' or 'LineNr', n, width) .. fold_mark(lnum) .. ' '
end

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

