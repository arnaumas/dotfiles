local wezterm = require 'wezterm'
local act = wezterm.action

wezterm.on('last-output', function(win, pane)
	local proc = pane:get_foreground_process_info()
	if not (proc and proc.name:match 'zsh$') then
		return
	end
	local zones = pane:get_semantic_zones 'Output'
	local zone = zones[#zones]
	if not zone then
		return
	end
	local f = io.open('/tmp/wezterm-out-' .. pane:pane_id(), 'w')
	if not f then
		return
	end
	f:write(pane:get_text_from_semantic_zone(zone))
	f:close()
	win:perform_action(act.SendString '\x1b@seq@', pane)
end)
