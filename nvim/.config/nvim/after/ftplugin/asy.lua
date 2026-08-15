local nmap_leader = function(suffix, rhs, desc, opts)
	opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end

vim.bo.makeprg = 'asy -o %:r %'
vim.bo.errorformat = table.concat({
	'%f: %l.%c: %m',
	'%f: %l.%c: %tarning: %m',
}, ',')

local viewed = false

local function view()
	local pdf = vim.fn.expand('%:r') .. '.pdf'
	if vim.fn.filereadable(pdf) == 0 then
		return
	end
	vim.fn.jobstart({ vim.g.vimtex_view_sioyek_exe, pdf }, { detach = true })
	viewed = true
end

local function errors()
	local n = 0
	for _, e in ipairs(vim.fn.getqflist()) do
		if e.valid == 1 then
			n = n + 1
		end
	end
	return n
end

nmap_leader('ll', function()
	vim.cmd.update({ mods = { silent = true } })
	vim.cmd.make({ mods = { silent = true } })
	vim.cmd.cwindow()
	if errors() > 0 then return end
	vim.notify('asy: compiled')
	if not viewed then
		view()
	end
end, 'compile', { silent = true, buffer = true })

nmap_leader('lv', function() view() end, 'view', { silent = true, buffer = true })
