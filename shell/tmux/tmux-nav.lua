local tmux_dir = { h = 'L', j = 'D', k = 'U', l = 'R' }

function _G.tmux_nav(dir)
	if vim.bo.filetype == 'fzf' then
		local k = vim.api.nvim_replace_termcodes('<C-' .. dir .. '>', true, false, true)
		vim.api.nvim_feedkeys(k, 'n', false)
		return
	end
	local prev = vim.api.nvim_get_current_win()
	vim.cmd.wincmd(dir)
	if prev == vim.api.nvim_get_current_win() and vim.env.TMUX then
		vim.fn.system({ 'tmux', 'select-pane', '-' .. tmux_dir[dir] })
	end
end
