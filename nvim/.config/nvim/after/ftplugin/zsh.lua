local set = vim.opt

set.foldmethod    = 'marker'
set.foldmarker    = ' -->,<--'
set.wrap          = false
set.sidescrolloff = 12
set.foldtext      = ''    -- draw the fold's first line with its own syntax

-- custom foldtext; re-enable with set.foldtext = 'v:lua.FoldText()'
-- FoldText = function()
-- 	local line = vim.fn.getline(vim.v.foldstart)
-- 	return line:gsub('^# ', '')
-- end
