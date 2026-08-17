local set = vim.opt

set.foldmethod    = 'marker'
set.foldmarker    = ' -->,<--'
set.wrap          = false
set.sidescrolloff = 12
set.foldtext      = 'v:lua.FoldText()'
set.foldcolumn    = 'auto'

-- custom foldtext
FoldText = function()
	local line = vim.fn.getline(vim.v.foldstart)
	return line:gsub('^-- ', '')
end
