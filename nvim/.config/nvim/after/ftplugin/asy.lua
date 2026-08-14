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
	vim.fn.jobstart({
		'/Applications/sioyek.app/Contents/MacOS/sioyek',
		'--reuse-window',
		vim.fn.expand('%:r') .. '.pdf',
	}, { detach = true })
	viewed = true
end

nmap_leader('ll', function()
	vim.cmd.update()
	vim.cmd.make()
	vim.cmd.cwindow()
	if vim.v.shell_error == 0 and not viewed then
		view()
	end
end, 'compile', { silent = true, buffer = true })

nmap_leader('lv', function() view() end, 'view', { silent = true, buffer = true })
