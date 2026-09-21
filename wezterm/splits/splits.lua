local wezterm = require 'wezterm'
local act = wezterm.action
local dirs = { h = 'Left', j = 'Down', k = 'Up', l = 'Right' }
local forward = { vim = true, nvim = true, view = true, fzf = true, tmux = true }
local skip = { Stop = true, Zombie = true, Dead = true }

-- walks children: zsh widgets run fzf under the shell
local function wants_keys(proc)
	if not proc or skip[proc.status] then
		return false
	end
	if forward[proc.name] then
		return true
	end
	for _, child in pairs(proc.children or {}) do
		if wants_keys(child) then
			return true
		end
	end
	return false
end

for key, dir in pairs(dirs) do
	wezterm.on('nav-' .. key, function(win, pane)
		if wants_keys(pane:get_foreground_process_info()) then
			win:perform_action(act.SendKey { key = key, mods = 'CTRL' }, pane)
		else
			win:perform_action(act.ActivatePaneDirection(dir), pane)
		end
	end)
end

local function active(tab)
	for _, p in ipairs(tab:panes_with_info()) do
		if p.is_active then
			return p
		end
	end
end

-- innermost split axis: a neighbour spanning exactly this pane is its sibling
local function split_axis(tab)
	local me, fallback = active(tab), nil
	for _, dir in ipairs { 'Right', 'Left', 'Down', 'Up' } do
		local n = tab:get_pane_direction(dir)
		if n then
			local x = dir == 'Right' or dir == 'Left'
			for _, p in ipairs(tab:panes_with_info()) do
				if p.pane:pane_id() == n:pane_id()
					and (x and p.top == me.top and p.height == me.height
						or not x and p.left == me.left and p.width == me.width) then
					return x
				end
			end
			if fallback == nil then
				fallback = x
			end
		end
	end
	return fallback
end

-- AdjustPaneSize moves the nearest divider; if the pane went the wrong way, reverse past the start
local function resize(grow)
	return function(win, pane)
		local tab = pane:tab()
		local x = split_axis(tab)
		if x == nil then
			return
		end
		local function size()
			local p = active(tab)
			return x and p.width or p.height
		end
		local before = size()
		win:perform_action(act.AdjustPaneSize { x and 'Right' or 'Down', 5 }, pane)
		local after = size()
		if after ~= before and (after > before) ~= grow then
			win:perform_action(act.AdjustPaneSize { x and 'Left' or 'Up', 10 }, pane)
		end
	end
end

wezterm.on('pane-grow', resize(true))
wezterm.on('pane-shrink', resize(false))
