-- math/verbatim node-type sets
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

-- nearest ancestor node in a type set
local function enclosing(row, col, set)
	local ok, node = pcall(vim.treesitter.get_node, { pos = { row, col } })
	if not ok or not node then return nil end
	while node do
		if set[node:type()] then return node end
		node = node:parent()
	end
	return nil
end

-- cursor-in-math test (drives the vimtex mathzone override)
function _G.tex_in_math()
	local pos = vim.api.nvim_win_get_cursor(0)
	local row, col = pos[1] - 1, pos[2]
	if vim.startswith(vim.fn.mode(), 'i') and col > 0 then col = col - 1 end
	return enclosing(row, col, math_types) ~= nil
end

-- verbatim-aware indentexpr wrapping VimtexIndentExpr
function _G.tex_in_verbatim(lnum)
	return enclosing(lnum - 1, math.max(vim.fn.indent(lnum), 0), verbatim_types) ~= nil
end

function _G.tex_indent()
	if _G.tex_in_verbatim(vim.v.lnum) then return -1 end
	return vim.fn.VimtexIndentExpr()
end
