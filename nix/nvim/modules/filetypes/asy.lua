local function errors()
	local n = 0
	for _, e in ipairs(vim.fn.getqflist()) do
		if e.valid == 1 then n = n + 1 end
	end
	return n
end

local function view()
	local pdf = vim.fn.expand('%:r') .. '.pdf'
	if vim.fn.filereadable(pdf) == 0 then return end
	vim.fn.jobstart({ vim.g.vimtex_view_sioyek_exe, pdf }, { detach = true })
	vim.b.asy_viewed = true
end

local function compile()
	vim.cmd.update({ mods = { silent = true } })
	vim.cmd.make({ mods = { silent = true } })
	vim.cmd.cwindow()
	if errors() > 0 then return end
	vim.notify('asy: compiled')
	if not vim.b.asy_viewed then view() end
end
