local wezterm = require 'wezterm'
local c = require 'colors'
local home = os.getenv 'HOME'

-- later: relative to the session root
local function rel(path)
	if path:sub(1, #home) == home then
		return '~' .. path:sub(#home + 1)
	end
	return path
end

-- unset titles fall back to the process name
local function name(pane)
	local proc = (pane.foreground_process_name or ''):match '[^/]+$' or ''
	if pane.title ~= '' and pane.title ~= proc then
		return pane.title
	end
	local cwd = pane.current_working_dir
	if proc == 'zsh' and cwd then
		return rel(cwd.file_path)
	end
	return proc
end

wezterm.on('format-tab-title', function(tab, _, _, _, _, max_width)
	local pane = tab.active_pane
	local zoom = pane.is_zoomed and ' Z' or ''
	local text = ' ' .. tab.tab_index .. ': ' .. name(pane) .. zoom .. ' '
	text = wezterm.truncate_right(text, max_width)
	if tab.is_active then
		return { { Attribute = { Intensity = 'Bold' } }, { Text = text } }
	end
	return text
end)

wezterm.on('update-status', function(win)
	win:set_left_status(win:leader_is_active() and wezterm.format {
		{ Background = { Color = c.prefix } },
		{ Text = ' ' },
	} or '')
	local session = win:active_workspace()
	win:set_right_status(session ~= 'default' and wezterm.format {
		{ Attribute = { Intensity = 'Bold' } },
		{ Foreground = { Color = c.session.fg } },
		{ Background = { Color = c.session.bg } },
		{ Text = ' ' .. session .. ' ' },
	} or '')
end)
