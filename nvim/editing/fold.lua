-- fold text
local function hl_at(info)
	local ts = info.treesitter
	if ts then
		for i = #ts, 1, -1 do
			local cap = ts[i].capture
			if cap ~= 'spell' and cap ~= 'nospell' and cap ~= 'conceal' then
				return ts[i].hl_group
			end
		end
	end
	local syn = info.syntax
	if syn and #syn > 0 then return syn[#syn].hl_group end
	return 'Normal'
end

local function line_chunks(lnum)
	local buf = vim.api.nvim_get_current_buf()
	local line = vim.fn.getline(lnum)
	if line == '' then return {} end
	local row = lnum - 1
	local chunks, cur, start = {}, nil, 0
	for col = 0, #line - 1 do
		local info = vim.inspect_pos(buf, row, col,
			{ syntax = true, treesitter = true, extmarks = false, semantic_tokens = false })
		local hl = hl_at(info)
		if hl ~= cur then
			if cur then chunks[#chunks + 1] = { line:sub(start + 1, col), cur } end
			cur, start = hl, col
		end
	end
	chunks[#chunks + 1] = { line:sub(start + 1), cur or 'Normal' }
	return chunks
end

function _G.make_foldtext()
	local chunks = line_chunks(vim.v.foldstart)
	chunks[#chunks + 1] = { '•••', 'FoldEllipsis' }
	return chunks
end
