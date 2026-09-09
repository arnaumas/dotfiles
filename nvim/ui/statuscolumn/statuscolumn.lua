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

-- true if a fold begins at lnum; v:lnum == lnum during statuscolumn eval.
local function fold_start(lnum)
	local cur = vim.fn.foldlevel(lnum)
	if cur == 0 then return false end
	local prev = lnum == 1 and 0 or vim.fn.foldlevel(lnum - 1)
	if cur > prev then return true end
	if cur < prev then return false end
	local fm = vim.wo.foldmethod
	if fm == 'expr' then
		local ok, v = pcall(vim.fn.eval, vim.wo.foldexpr)
		return ok and type(v) == 'string' and v:sub(1, 1) == '>'
	elseif fm == 'marker' then
		local open = vim.split(vim.wo.foldmarker, ',')[1]
		return open ~= '' and vim.fn.getline(lnum):find(open, 1, true) ~= nil
	end
	return false
end

-- fold marks only; a sign (if any) replaces the number, not this cell.
local function fold_mark(lnum, fc)
	if fc < 2 then return '%#FoldColumn#' .. string.rep(' ', fc) end
	if vim.fn.foldlevel(lnum) == 0 then return '%#FoldColumn#  ' end
	if vim.fn.foldclosed(lnum) ~= -1 then return '%#FoldColumn#\u{F460}' end
	if fold_start(lnum) then return '%#FoldColumn#\u{F47C}' end
	return '%#FoldColumn#\u{23B9} '
end

local function number(hl, n, cells)
	return ('%%#' .. hl .. '#%' .. cells .. 'd'):format(n)
end

local function num_field(lnum, width)
	local text, sign_hl = sign(lnum)
	if text then
		text = text:gsub('%s+$', '')
		local pad = string.rep(' ', math.max(0, width - vim.fn.strdisplaywidth(text)))
		return '%#' .. sign_hl .. '#' .. pad .. text
	end
	local cursor = vim.v.relnum == 0
	local n = cursor and lnum or vim.v.relnum
	return number(cursor and 'CursorLineNr' or 'LineNr', n, width)
end

function _G.make_statuscolumn()
	local lnum = vim.v.lnum
	local win = vim.g.statusline_winid
	if win == nil or win == 0 then win = vim.api.nvim_get_current_win() end
	local width = math.max(2, #tostring(vim.api.nvim_win_get_cursor(win)[1]))
	local ok, folds = pcall(vim.api.nvim_win_get_var, win, 'statuscolumn_folds')
	local fc = (ok and folds) and 2 or 1
	if vim.v.virtnum > 0 then
		local mark
		if fc < 2 then
			mark = '%#FoldColumn#' .. string.rep(' ', fc)
		else
			mark = vim.fn.foldlevel(lnum) > 0 and '%#FoldColumn#\u{23B9} ' or '%#FoldColumn#  '
		end
		return string.rep(' ', width) .. mark
	end
	if vim.v.virtnum < 0 then return '' end
	return num_field(lnum, width) .. fold_mark(lnum, fc)
end

local function window_has_folds()
	for l = vim.fn.line('w0'), vim.fn.line('w$') do
		if vim.fn.foldlevel(l) > 0 then return true end
	end
	return false
end

vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI', 'WinScrolled', 'BufWinEnter' }, {
	callback = function()
		local w = math.max(2, #tostring(vim.fn.line('.')))
		local folds = window_has_folds()
		if vim.w.statuscolumn_width ~= w or vim.w.statuscolumn_folds ~= folds then
			vim.w.statuscolumn_width = w
			vim.w.statuscolumn_folds = folds
			vim.wo.statuscolumn = vim.wo.statuscolumn
		end
	end,
})
