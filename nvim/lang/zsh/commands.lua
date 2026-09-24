local known
local cache = {}

local function load_known()
	known = {}
	local names = vim.fn.systemlist({ "zsh", "-fc", "print -l ${(k)builtins} ${(k)reswords}" })
	for _, name in ipairs(names) do
		known[name] = true
	end
	for name in (vim.env.ZLE_NAMES or ""):gmatch("%S+") do
		known[name] = true
	end
end

local function is_command(name)
	if cache[name] == nil then
		if not known then
			load_known()
		end
		cache[name] = known[name] or vim.fn.executable(name) == 1
	end
	return cache[name]
end

vim.treesitter.query.add_predicate("command?", function(match, _, source, pred)
	for _, node in ipairs(match[pred[2]] or {}) do
		if not is_command(vim.treesitter.get_node_text(node, source)) then
			return false
		end
	end
	return true
end, { force = true })
