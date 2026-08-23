local function tex_notify(msg, level)
	vim.notify('VimTeX: ' .. msg, level)
end

local tex_events = {
	VimtexEventCompileStarted = function() tex_notify('compiling ' .. vim.b.vimtex.base, vim.log.levels.INFO) end,
	VimtexEventCompileSuccess = function() tex_notify('compiled ' .. vim.b.vimtex.base, vim.log.levels.INFO) end,
	VimtexEventCompileStopped = function() tex_notify('compiler stopped', vim.log.levels.WARN) end,
	VimtexEventCompileFailed = function()
		tex_notify(('failed (%d qf entries)'):format(#vim.fn.getqflist()), vim.log.levels.ERROR)
	end,
}

for pattern, callback in pairs(tex_events) do
	vim.api.nvim_create_autocmd('User', { pattern = pattern, callback = callback })
end
