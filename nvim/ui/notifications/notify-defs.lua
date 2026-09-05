_M.notify = {
	dot = {
		ERROR = '\u{F057}', WARN = '\u{F071}', INFO = '\u{F05A}',
		DEBUG = '\u{F013}', TRACE = '\u{F058}', OFF = ' ',
	},
	dot_ns = vim.api.nvim_create_namespace('mini-notify-dot'),
	dot_hl = { ERROR = 'NtfError', WARN = 'NtfWarn', INFO = 'NtfInfo',
		DEBUG = 'NtfHint', TRACE = 'NtfOk', OFF = 'MiniNotifyNormal' },
	line_hl = {},
	in_history = false,
}

-- '<dot> │ msg' popup, '<dot> │ HH:MM:SS │ msg' history. Dot glyph per level,
-- colored via a higher-priority ephemeral extmark in the decoration provider.
function _M.notify.format(notif)
	local n = _M.notify
	local msg = notif.msg
	if n.in_history then
		msg = vim.fn.strftime('%H:%M:%S', math.floor(notif.ts_update)) .. ' ' .. msg
	end
	local dot = n.dot[notif.level] or n.dot.INFO
	local res = dot .. ' ' .. msg
	n.line_hl[vim.split(res, '\n')[1]] = { hl = n.dot_hl[notif.level] or n.dot_hl.INFO, len = #dot }
	return res
end
