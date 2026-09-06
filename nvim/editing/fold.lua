local function ts_hls(buf, row, len)
	local best = {}
	local state = vim.treesitter.highlighter.active[buf]
	if not state then return best end
	state.tree:for_each_tree(function(tstree, ltree)
		if not tstree then return end
		local root = tstree:root()
		local rs, _, re = root:range()
		if rs > row or re < row then return end
		local lang = ltree:lang()
		local query = vim.treesitter.query.get(lang, 'highlights')
		if not query then return end
		for capture, node, metadata in query:iter_captures(root, buf, row, row + 1) do
			local name = query.captures[capture]
			if not vim.startswith(name, '_')
				and name ~= 'spell' and name ~= 'nospell' and name ~= 'conceal' then
				local r = vim.treesitter.get_range(node, buf, metadata and metadata[capture])
				local srow, scol, erow, ecol = r[1], r[2], r[4], r[5]
				local prio = tonumber(metadata.priority
					or (metadata[capture] and metadata[capture].priority))
					or vim.hl.priorities.treesitter
				local from = (srow < row) and 0 or scol
				local to = (erow > row) and len or ecol
				local hl = '@' .. name .. '.' .. lang
				for c = from, to - 1 do
					local b = best[c]
					if not b or prio >= b.prio then best[c] = { hl = hl, prio = prio } end
				end
			end
		end
	end)
	return best
end

local function line_chunks(lnum)
	local buf = vim.api.nvim_get_current_buf()
	local line = vim.fn.getline(lnum)
	if line == '' then return {} end
	local row, len = lnum - 1, #line
	local best = ts_hls(buf, row, len)
	local chunks, cur, start = {}, nil, 0
	for c = 0, len - 1 do
		local hl = best[c] and best[c].hl
		if not hl then
			local sid = vim.fn.synID(lnum, c + 1, 1)
			if sid ~= 0 then hl = vim.fn.synIDattr(sid, 'name') end
		end
		hl = hl or 'Normal'
		if hl ~= cur then
			if cur then chunks[#chunks + 1] = { line:sub(start + 1, c), cur } end
			cur, start = hl, c
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
