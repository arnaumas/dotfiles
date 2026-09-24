local wezterm = require 'wezterm'

local function px(v)
	return tonumber((v or '0'):match '^[%d.]+') or 0
end

-- leftover pixels go to the top, so the last row meets the tab bar
return function(padding)
	local function fit(win)
		local tab = win:active_tab()
		if not tab then
			return
		end
		local pane = tab:panes_with_info()[1]
		local cell = pane.pixel_height / pane.height
		local overrides = win:get_config_overrides() or {}
		local top = (overrides.window_padding or {}).top
		local free = win:get_dimensions().pixel_height - cell - px(padding.bottom)
		local want = math.floor(free % cell) .. 'px'
		if top ~= want then
			local pad = { top = want }
			for k, v in pairs(padding) do
				pad[k] = pad[k] or v
			end
			overrides.window_padding = pad
			win:set_config_overrides(overrides)
		end
	end
	wezterm.on('window-resized', fit)
	wezterm.on('window-config-reloaded', fit)
end
