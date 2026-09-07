local ok_utils, utils = pcall(require, 'fzf-lua.utils')

local function paint(hl, s)
	if s == '' or not ok_utils or not utils.ansi_from_hl then return s end
	local out = utils.ansi_from_hl(hl, s)
	return type(out) == 'string' and out or s
end

local function jump(entry)
	if entry.file and entry.file ~= '' and entry.file ~= vim.api.nvim_buf_get_name(0) then
		vim.cmd.edit(vim.fn.fnameescape(entry.file))
	end
	if entry.line then
		local last = vim.api.nvim_buf_line_count(0)
		local line = math.min(math.max(tonumber(entry.line) or 1, 1), last)
		vim.api.nvim_win_set_cursor(0, { line, 0 })
		vim.cmd('normal! zvzz')
	end
end

local function collect(kind)
	local out = {}
	for _, e in ipairs(vim.fn['vimtex#toc#get_entries']()) do
		if e.type == kind then out[#out + 1] = e end
	end
	return out
end

local function run(items, prompt, fmt)
	local lines = {}
	local width = 0
	for i, e in ipairs(items) do
		local plain, painted = fmt(e)
		width = math.max(width, vim.fn.strdisplaywidth(plain))
		lines[#lines + 1] = string.format('%d\t%s', i, painted)
	end

	local status = vim.o.laststatus > 0 and 1 or 0
	local win_w = math.min(width + 4, vim.o.columns - 4)
	local win_h = vim.o.lines - vim.o.cmdheight - status

	require('fzf-lua').fzf_exec(lines, {
		prompt = prompt,
		winopts = { row = 0, col = 0, width = win_w, height = win_h },
		fzf_opts = {
			['--ansi'] = true,
			['--delimiter'] = '\\t',
			['--with-nth'] = '2..',
		},
		actions = {
			default = function(selected)
				if not selected or not selected[1] then return end
				local idx = tonumber(selected[1]:match('^(%d+)\t'))
				if idx and items[idx] then jump(items[idx]) end
			end,
		},
	})
end

-- toc
local function truthy(v)
	return v ~= nil and v ~= 0 and v ~= ''
end

local ROMAN = {
	{ 1000, 'M' }, { 900, 'CM' }, { 500, 'D' }, { 400, 'CD' },
	{ 100, 'C' }, { 90, 'XC' }, { 50, 'L' }, { 40, 'XL' },
	{ 10, 'X' }, { 9, 'IX' }, { 5, 'V' }, { 4, 'IV' }, { 1, 'I' },
}

local function int_to_roman(n)
	local out = ''
	for _, pair in ipairs(ROMAN) do
		while n >= pair[1] do
			n = n - pair[1]
			out = out .. pair[2]
		end
	end
	return out
end

local function format_number(number)
	if number == nil or number == '' then return '' end
	if type(number) == 'string' then return number end
	if truthy(number.part_toggle) then return int_to_roman(number.part) end

	local parts = {
		number.chapter, number.section, number.subsection,
		number.subsubsection, number.subsubsubsection,
	}
	while #parts > 0 and parts[1] == 0 do table.remove(parts, 1) end
	while #parts > 0 and parts[#parts] == 0 do table.remove(parts) end

	if truthy(number.frontmatter) or truthy(number.backmatter) then
		return ''
	elseif truthy(number.appendix) and parts[1] then
		parts[1] = string.char(parts[1] + 64)
	end

	return table.concat(parts, '.')
end

local function sec_hl(depth)
	return 'VimtexTocSec' .. math.min(depth, 4)
end

function _G.tex_toc_fzf()
	local items = collect('content')
	if #items == 0 then
		vim.notify('vimtex: no toc entries', vim.log.levels.INFO)
		return
	end
	run(items, 'toc > ', function(e)
		local depth = tonumber(e.level) or 0
		local indent = string.rep('  ', depth)
		local num = format_number(e.number)
		local num_pfx = num ~= '' and (num .. '  ') or ''
		local title = (e.title or ''):gsub('%s+', ' ')
		local painted = indent .. paint('VimtexTocNum', num_pfx) .. paint(sec_hl(depth), title)
		return indent .. num_pfx .. title, painted
	end)
end

-- labels
local function is_section(prefix)
	return prefix == 'chap' or prefix:match('sec$') ~= nil
end

local function ref_group(prefix)
	if prefix == 'eq' then return 'TexRefEq' end
	if prefix == 'fig' then return 'TexRefFig' end
	if prefix == 'tab' then return 'TexRefTab' end
	return 'TexRefOther'
end

function _G.tex_labels_fzf()
	local items = {}
	for _, e in ipairs(collect('label')) do
		if not is_section((e.title or ''):match('^(%a+):') or '') then
			items[#items + 1] = e
		end
	end
	if #items == 0 then
		vim.notify('vimtex: no labels', vim.log.levels.INFO)
		return
	end
	run(items, 'labels > ', function(e)
		local title = (e.title or ''):gsub('%s+', ' ')
		local prefix, rest = title:match('^(%a+)(:.*)$')
		if not prefix then return title, title end
		return title, paint(ref_group(prefix), prefix) .. rest
	end)
end

-- todo
local function todo_group(label)
	local l = label:lower()
	if l:match('fatal$') then return 'TexTodoFatal' end
	if l:match('error$') then return 'TexTodoError' end
	if l:match('warning$') then return 'TexTodoWarn' end
	if l:match('note$') then return 'TexTodoNote' end
	return 'TexTodo'
end

function _G.tex_todo_fzf()
	local items = collect('todo')
	if #items == 0 then
		vim.notify('vimtex: no todos', vim.log.levels.INFO)
		return
	end
	run(items, 'todo > ', function(e)
		local title = (e.title or ''):gsub('%s+', ' ')
		local label, rest = title:match('^(%a+)(:.*)$')
		if not label then return title, title end
		return title, paint(todo_group(label), label) .. rest
	end)
end
