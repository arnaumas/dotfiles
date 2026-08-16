local set = vim.opt

set.foldmethod    = 'marker'
set.foldmarker    = ' -->,<--'
set.wrap          = false
set.sidescrolloff = 12

-- header stripping, superseded by the global FoldText in 10_options; fold
-- markers are shown as-is now. To bring it back, strip inside that function.
-- local line = vim.fn.getline(vim.v.foldstart)
-- return line:gsub('^# ', '')
