local map = vim.keymap.set
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

map('n', 'o', 'o<esc>', { desc = '[o]pen line' })
map('n', 'O', 'O<esc>', { desc = '[o]pen line above' })

map('n', '<C-h>', '<C-w><C-h>', { desc = 'move focus to the window to the left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'move focus to the window to the right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'move focus to the window below' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'move focus to the window above' })

map('n', '<esc>', '<cmd>nohlsearch<cr>', { desc = 'clear highlights' })

-- map('n', '<leader>pv', vim.cmd.Ex, { desc = '[p]roject [v]iew'})

map('n', '<leader>w', function() vim.cmd('silent write') end, { desc = '[w]rite file' })
map('n', '<leader>s', vim.cmd.source, { desc = '[s]ource file' })
map('n', '<leader>q', vim.cmd.quit, { desc = '[q]uit file' })

map('n', '<leader>bn', vim.cmd.bn, { desc = '[b]uffer [n]ext' })
map('n', '<leader>bp', vim.cmd.bp, { desc = '[b]uffer [p]revious' })
map('n', '<leader>bd', vim.cmd.bd, { desc = '[b]uffer [d]elete' })

map('n', ':', 'q:')
map('n', '/', 'q/i')

-- mini.pick bindings ->
later(function()
	local pick = require('mini.pick')
	local extra = require('mini.extra')
	map('n', '<leader>ff', pick.builtin.files, { desc = '[f]ind in [f]iles' })
	map('n', '<leader>fb', pick.builtin.buffers, { desc = '[f]ind in open [b]uffers' })
	map('n', '<leader>fg', pick.builtin.grep_live, { desc = '[f]ind in [g]rep file' })
	map('n', '<leader>fh', pick.builtin.help, { desc = '[f]ind in [h]elp' })
	map('n', '<leader>fH', extra.pickers.hl_groups, { desc = '[f]ind in [H]ighlight groups' })
	map('n', '<leader>fl', '<Cmd>Pick buf_lines scope="current"<CR>', { desc = '[f]ind in buffer [l]ines' })
	map('n', '<leader>fL', '<Cmd>Pick buf_lines scope="all"<CR>', { desc = '[f]ind in all buffer [l]ines' })
end)
-- <- 

-- mini.git bindings ->
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
map('n', '<leader>gc', '<Cmd>Git commit<CR>', { desc = '[g]it [c]ommit' })
-- <- 
--
-- mini.files bindings ->
map('n', '<leader>ed', '<cmd>lua MiniFiles.open()<cr>',                             { desc = '[e]xplore [d]irectory' })
map('n', '<leader>ef', '<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<cr>', { desc = '[e]xplore [f]ile directory' })
-- <- 

-- luasnip expand snippet keymaps ->
later(function()
	local luasnip = require 'luasnip'

	map({'i','s'}, '<C-l>', function()
		if luasnip.expand_or_locally_jumpable() then
			luasnip.expand_or_jump()
		end
	end, { silent = true })

	map({'i','s'}, '<C-h>', function()
		if luasnip.locally_jumpable(-1) then
			luasnip.jump(-1)
		end
	end, { silent = true })
end)
-- <-
