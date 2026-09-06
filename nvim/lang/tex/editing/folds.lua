-- fold-range helpers
local function last_nonblank(bufnr, from, floor)
	local last = from
	while last > floor do
		local l = vim.api.nvim_buf_get_lines(bufnr, last, last + 1, false)[1]
		if l and l:match('%S') then break end
		last = last - 1
	end
	return last
end

local function end_range(bufnr, sr, sc, sb, last)
	local line = vim.api.nvim_buf_get_lines(bufnr, last, last + 1, false)[1] or ''
	return { sr, sc, sb, last, #line, vim.api.nvim_buf_get_offset(bufnr, last) + #line }
end

-- trim-blank!: end a fold at its last non-blank line
vim.treesitter.query.add_directive('trim-blank!', function(match, _, bufnr, pred, metadata)
	local id = pred[2]
	local node = match[id]
	if type(node) == 'table' then node = node[#node] end
	if not node then return end
	local sr, sc, sb, er, ec = node:range(true)
	local last = last_nonblank(bufnr, ec == 0 and er - 1 or er, sr)
	metadata[id] = metadata[id] or {}
	metadata[id].range = end_range(bufnr, sr, sc, sb, last)
end, { force = true })

-- prelude!: fold the span before a node (document prelude)
vim.treesitter.query.add_directive('prelude!', function(match, _, bufnr, pred, metadata)
	local id = pred[2]
	local node = match[id]
	if type(node) == 'table' then node = node[1] end
	if not node then return end
	local br = node:range()
	if br <= 0 then return end
	local last = last_nonblank(bufnr, br - 1, 0)
	metadata[id] = metadata[id] or {}
	metadata[id].range = end_range(bufnr, 0, 0, 0, last)
end, { force = true })
