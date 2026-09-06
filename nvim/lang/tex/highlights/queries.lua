-- math node-type set
local math_types = {
	inline_formula = true,
	displayed_equation = true,
	math_environment = true,
}

-- first-char!: shrink a capture to its first character
vim.treesitter.query.add_directive('first-char!', function(match, _, _, pred, metadata)
	local id = pred[2]
	local node = match[id]
	if type(node) == 'table' then node = node[#node] end
	if not node then return end
	local sr, sc, sb = node:range(true)
	metadata[id] = metadata[id] or {}
	metadata[id].range = { sr, sc, sb, sr, sc + 1, sb + 1 }
end, { force = true })

-- in-math?: true if the node is inside a math node
vim.treesitter.query.add_predicate('in-math?', function(match, _, _, pred)
	local node = match[pred[2]]
	if type(node) == 'table' then node = node[1] end
	while node do
		if math_types[node:type()] then return true end
		node = node:parent()
	end
	return false
end, { force = true })
