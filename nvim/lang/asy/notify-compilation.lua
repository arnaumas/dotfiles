local function asymptote_errors()
	local n = 0
	for _, e in ipairs(vim.fn.getqflist()) do
		if e.valid == 1 then n = n + 1 end
	end
	return n
end

local function asymptote_view()
	local pdf = vim.fn.expand('%:r') .. '.pdf'
	if vim.fn.filereadable(pdf) == 0 then return end
	vim.fn.jobstart({ vim.g.vimtex_view_sioyek_exe, pdf }, { detach = true })
	vim.b.asy_viewed = true
end

local function asymptote_compile()
	vim.cmd.update({ mods = { silent = true } })
	vim.notify('asy: compiling ' .. vim.fn.expand('%:t'), vim.log.levels.INFO)
	vim.cmd.make({ mods = { silent = true } })
	vim.cmd.cwindow()
	local errs = asymptote_errors()
	if errs > 0 then
		vim.notify(('asy: failed (%d qf entries)'):format(errs), vim.log.levels.ERROR)
		return
	end
	vim.notify('asy: compiled', vim.log.levels.INFO)
	if not vim.b.asy_viewed then asymptote_view() end
end
