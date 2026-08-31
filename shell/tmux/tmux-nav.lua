local tmux_dir = { h = 'L', j = 'D', k = 'U', l = 'R' }

function _G.tmux_nav(dir)
	local prev = vim.api.nvim_get_current_win()
	vim.cmd.wincmd(dir)
	if prev == vim.api.nvim_get_current_win() and vim.env.TMUX then
		vim.fn.system({ 'tmux', 'select-pane', '-' .. tmux_dir[dir] })
	end
end
