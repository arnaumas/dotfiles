local math_types = {
	inline_formula = true,
	displayed_equation = true,
	math_environment = true,
}
local verbatim_types = {
	minted_environment = true,
	verbatim_environment = true,
	listing_environment = true,
}

vim.treesitter.query.add_directive('first-char!', function(match, _, _, pred, metadata)
	local id = pred[2]
	local node = match[id]
	if type(node) == 'table' then node = node[#node] end
	if not node then return end
	local sr, sc, sb = node:range(true)
	metadata[id] = metadata[id] or {}
	metadata[id].range = { sr, sc, sb, sr, sc + 1, sb + 1 }
end, { force = true })

vim.treesitter.query.add_predicate('in-math?', function(match, _, _, pred)
	local node = match[pred[2]]
	if type(node) == 'table' then node = node[1] end
	while node do
		if math_types[node:type()] then return true end
		node = node:parent()
	end
	return false
end, { force = true })

local function enclosing(row, col, set)
	local ok, node = pcall(vim.treesitter.get_node, { pos = { row, col } })
	if not ok or not node then return nil end
	while node do
		if set[node:type()] then return node end
		node = node:parent()
	end
	return nil
end

function _G.tex_in_math()
	local pos = vim.api.nvim_win_get_cursor(0)
	local row, col = pos[1] - 1, pos[2]
	if vim.startswith(vim.fn.mode(), 'i') and col > 0 then col = col - 1 end
	return enclosing(row, col, math_types) ~= nil
end

function _G.tex_math_textobject(ai_type)
	local pos = vim.api.nvim_win_get_cursor(0)
	local node = enclosing(pos[1] - 1, pos[2], math_types)
	if not node then return nil end
	if ai_type == 'a' then
		local sr, sc, er, ec = node:range()
		return { from = { line = sr + 1, col = sc + 1 }, to = { line = er + 1, col = ec } }
	end
	local cc = node:child_count()
	if cc < 2 then return nil end
	local _, _, oer, oec = node:child(0):range()
	local csr, csc = node:child(cc - 1):range()
	if csr < oer or (csr == oer and csc <= oec) then return nil end
	return { from = { line = oer + 1, col = oec + 1 }, to = { line = csr + 1, col = csc } }
end

function _G.tex_in_verbatim(lnum)
	return enclosing(lnum - 1, math.max(vim.fn.indent(lnum), 0), verbatim_types) ~= nil
end

function _G.tex_indent()
	if _G.tex_in_verbatim(vim.v.lnum) then return -1 end
	return vim.fn.VimtexIndentExpr()
end

local grp = vim.api.nvim_create_augroup('tex-treesitter', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
	group = grp,
	pattern = 'tex',
	callback = function(args)
		if not vim.g.tex_mathzone_override then
			vim.cmd([[
				silent! call vimtex#syntax#in_mathzone()
				function! vimtex#syntax#in_mathzone(...) abort
					return luaeval('_G.tex_in_math()')
				endfunction
			]])
			vim.g.tex_mathzone_override = 1
		end
		vim.b[args.buf].miniai_config = {
			custom_textobjects = { ['$'] = _G.tex_math_textobject },
		}
		vim.schedule(function()
			if vim.api.nvim_buf_is_valid(args.buf) then
				vim.bo[args.buf].indentexpr = 'v:lua.tex_indent()'
			end
		end)
	end,
})
