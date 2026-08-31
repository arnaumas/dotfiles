-- gutter
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

-- one cell after the number: a sign draws over the fold marker
local function gutter_mark(lnum)
	local text, hl = sign(lnum)
	if text then return '%#' .. hl .. '#' .. (text:gsub('%s+$', '')) end
	return fold_mark(lnum)
end

function _G.make_statuscolumn()
	local lnum = vim.v.lnum
	-- number field fits the current line; floor of 2 for relnums (mark cell adds one)
	local width = math.max(#tostring(vim.fn.line('.')), 2)
	if vim.v.virtnum > 0 then
		local mark = vim.fn.foldlevel(lnum) > 0 and '%#FoldColumn#\u{23B9}' or ' '
		return string.rep(' ', width) .. mark
	end
	if vim.v.virtnum < 0 then return '' end
	local cursor = vim.v.relnum == 0
	local n = cursor and lnum or vim.v.relnum
	return number(cursor and 'CursorLineNr' or 'LineNr', n, width) .. gutter_mark(lnum)
end
