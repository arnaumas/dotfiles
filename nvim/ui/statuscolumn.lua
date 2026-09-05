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

local function fold_mark(lnum)
	local text, sign_hl = sign(lnum)
	if text then return '%#' .. sign_hl .. '#' .. text:gsub('%s+$', '') end
	if vim.fn.foldlevel(lnum) == 0 then return '%#FoldColumn# ' end
	if vim.fn.foldclosed(lnum) ~= -1 then return '%#FoldColumn#\u{F460}' end
	if lnum == 1 or vim.fn.foldlevel(lnum) > vim.fn.foldlevel(lnum - 1) then
		return '%#FoldColumn#\u{F47C}'
	end
	return '%#FoldColumn#\u{23B9}'
end

local function number(hl, n, cells)
	return ('%%#' .. hl .. '#%' .. cells .. 'd'):format(n)
end

function _G.make_statuscolumn()
	local lnum = vim.v.lnum
	local win = vim.g.statusline_winid
	if win == nil or win == 0 then win = vim.api.nvim_get_current_win() end
	local width = math.max(2, #tostring(vim.api.nvim_win_get_cursor(win)[1]))
	if vim.v.virtnum > 0 then
		local mark = vim.fn.foldlevel(lnum) > 0 and '%#FoldColumn#\u{23B9}' or '%#FoldColumn# '
		return string.rep(' ', width) .. mark
	end
	if vim.v.virtnum < 0 then return '' end
	local cursor = vim.v.relnum == 0
	local n = cursor and lnum or vim.v.relnum
	return number(cursor and 'CursorLineNr' or 'LineNr', n, width) .. fold_mark(lnum)
end

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
	callback = function()
		local w = math.max(2, #tostring(vim.fn.line('.')))
		if vim.w.statuscolumn_width ~= w then
			vim.w.statuscolumn_width = w
			vim.wo.statuscolumn = vim.wo.statuscolumn
		end
	end,
})
