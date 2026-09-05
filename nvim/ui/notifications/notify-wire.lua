local n = _M.notify
vim.api.nvim_set_decoration_provider(n.dot_ns, {
	on_win = function(_, _, buf) return vim.bo[buf].filetype:find('^mininotify') ~= nil end,
	on_line = function(_, _, buf, row)
		local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
		local e = line ~= nil and n.line_hl[line] or nil
		if e == nil then return end
		vim.api.nvim_buf_set_extmark(buf, n.dot_ns, row, 0,
			{ end_col = e.len, hl_group = e.hl, priority = 5000, ephemeral = true })
	end,
})

-- make_notify defaults DEBUG/TRACE/OFF to duration 0 (disabled); set it so they show.
local plain = { hl_group = 'MiniNotifyNormal', duration = 5000 }
vim.notify = require('mini.notify').make_notify({
	ERROR = plain, WARN = plain, INFO = plain, DEBUG = plain, TRACE = plain, OFF = plain,
})
