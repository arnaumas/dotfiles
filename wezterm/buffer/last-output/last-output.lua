local wezterm = require 'wezterm'
local act = wezterm.action

local function escapes(pane, zone)
	local dims = pane:get_dimensions()
	local bottom = dims.physical_top + dims.viewport_rows - 1
	local want = zone.end_y - zone.start_y + 1
	local lines = {}
	for line in (pane:get_lines_as_escapes(bottom - zone.start_y + 1) .. '\n'):gmatch '(.-)\n' do
		if #lines == want then
			break
		end
		lines[#lines + 1] = line
	end
	return table.concat(lines, '\n') .. '\n'
end

local function last_output(pane)
	local zones = pane:get_semantic_zones 'Output'
	local y = pane:get_cursor_position().y
	for i = #zones, 1, -1 do
		if zones[i].start_y < y then
			return zones[i]
		end
	end
end

wezterm.on('last-output', function(win, pane)
	local proc = pane:get_foreground_process_info()
	if not (proc and proc.name:match 'zsh$') then
		return
	end
	local zone = last_output(pane)
	if not zone then
		return
	end
	local f = io.open('/tmp/wezterm-out-' .. pane:pane_id(), 'w')
	if not f then
		return
	end
	f:write(escapes(pane, zone))
	f:close()
	win:perform_action(act.SendString '\x1b@seq@', pane)
end)
