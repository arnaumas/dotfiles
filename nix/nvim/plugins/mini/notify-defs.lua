_M.notify = {
	dot = '●',
	dot_ns = vim.api.nvim_create_namespace('mini-notify-dot'),
	dot_hl = { ERROR = 'DiagnosticError', WARN = 'DiagnosticWarn', INFO = 'DiagnosticInfo',
		DEBUG = 'DiagnosticHint', TRACE = 'DiagnosticOk', OFF = 'MiniNotifyNormal' },
	line_hl = {},
	in_history = false,
}

-- '● │ msg' popup, '● │ HH:MM:SS │ msg' history. Dot colored per level via a
-- higher-priority ephemeral extmark in the decoration provider (post).
function _M.notify.format(notif)
	local n = _M.notify
	local msg = notif.msg
	if n.in_history then
		msg = vim.fn.strftime('%H:%M:%S', math.floor(notif.ts_update)) .. ' ' .. msg
	end
	local res = ' ' .. n.dot .. ' ' .. msg
	n.line_hl[vim.split(res, '\n')[1]] = n.dot_hl[notif.level] or n.dot_hl.INFO
	return res
end
