local wezterm = require 'wezterm'

local function id(k)
	return k.key .. '|' .. (k.mods or 'NONE')
end

return function(config)
	if not wezterm.gui then
		return
	end
	local tables = wezterm.gui.default_key_tables()
	for name, extra in pairs(config.key_tables or {}) do
		local seen = {}
		for _, k in ipairs(extra) do
			seen[id(k)] = true
		end
		local merged = {}
		for _, k in ipairs(tables[name] or {}) do
			if not seen[id(k)] then
				merged[#merged + 1] = k
			end
		end
		for _, k in ipairs(extra) do
			merged[#merged + 1] = k
		end
		tables[name] = merged
	end
	config.key_tables = tables
end
