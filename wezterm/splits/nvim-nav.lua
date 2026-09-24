local dirs = { h = 'Left', j = 'Down', k = 'Up', l = 'Right' }

function _G.pane_nav(dir)
	if vim.bo.filetype == 'fzf' then
		local k = vim.api.nvim_replace_termcodes('<C-' .. dir .. '>', true, false, true)
		vim.api.nvim_feedkeys(k, 'n', false)
		return
	end
	local prev = vim.api.nvim_get_current_win()
	vim.cmd.wincmd(dir)
	if prev == vim.api.nvim_get_current_win() and vim.env.WEZTERM_PANE then
		vim.fn.system({ 'wezterm', 'cli', 'activate-pane-direction', dirs[dir] })
	end
end
