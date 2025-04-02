local map = vim.keymap.set
local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

local nmap_leader = function(suffix, rhs, desc, opts)
	opts = opts or {}
  opts.desc = desc
  vim.keymap.set('n', '<Leader>' .. suffix, rhs, opts)
end

-- editing ->
map('n', 'o', 'o<esc>', { desc = '[o]pen line' })
map('n', 'O', 'O<esc>', { desc = '[o]pen line above' })
map('n', 'r', 'cl', { desc = '[o]pen line above' })
map('n', 'R', 'cc', { desc = '[o]pen line above' })
map({ 'n', 'x' }, 'u', function() vim.cmd[[ silent undo ]] end )
map({ 'n', 'x' }, 's', '<nop>')
map({ 'n', 'x' }, 'S', '<nop>')
map({ 'n', 'x' }, 'K', 'i<cr><esc>')
--

-- <-

-- window moving and resizing ->
map('n', '<C-h>', '<C-w><C-h>', { desc = 'move focus to the window to the left' })
map('n', '<C-l>', '<C-w><C-l>', { desc = 'move focus to the window to the right' })
map('n', '<C-j>', '<C-w><C-j>', { desc = 'move focus to the window below' })
map('n', '<C-k>', '<C-w><C-k>', { desc = 'move focus to the window above' })
map('n', 'e<C-j>', '<cmd>resize -5 <cr>')
map('n', 'e<C-k>', '<cmd>res +5 <cr>')
-- <-

-- ui ->
map('n', '<esc>', '<cmd>nohlsearch<cr>', { desc = 'clear highlights' })
-- <-

-- cmdline ->
map({ 'n', 'x' }, '<leader>r', 'q', { desc = '[r]ecord macro'} )
map({ 'n', 'x' }, 'q', '<nop>')

map('n', ':', 'q:')
-- <-

-- b is for [b]uffer ->
nmap_leader('w', function() vim.cmd[[ silent write ]] end,     '[w]rite file')
nmap_leader('q', vim.cmd.quit,                                 '[q]uit file' )
nmap_leader('Q', function() vim.cmd.quit({ bang = true }) end, 'force [q]uit file' )

nmap_leader('bn', vim.cmd.bn, '[b]uffer [n]ext' )
nmap_leader('bp', vim.cmd.bp, '[b]uffer [p]revious' )
nmap_leader('bd', vim.cmd.bd, '[b]uffer [d]elete' )
nmap_leader('bs', vim.cmd.sp, '[b]uffer [s]plit' )
-- <-

-- e is for [e]xplore ->
local edit_config_file = function(filename)
	return '<Cmd>edit ' .. vim.fn.stdpath('config') .. '/plugin/' .. filename .. '<CR>'
end
local dotfiles = '/Users/arnau/dotfiles'
local config = function(tool) return '/Users/arnau/dotfiles/'.. tool .. '/.config/' .. tool end

nmap_leader('ef', function() MiniFiles.open(vim.api.nvim_buf_get_name(0)) end, '[e]xplore [f]ile directory' )
nmap_leader('edd', function() MiniFiles.open(dotfiles, false) end,             '[e]xplore [d]otfiles' )
nmap_leader('edn', function() MiniFiles.open(config('nvim'), false) end,       '[e]xplore [n]eovim [d]otfiles' )
nmap_leader('edz', function() MiniFiles.open(config('zsh'), false) end,        '[e]xplore [z]sh [d]otfiles' )
-- <- 

-- f is for [f]uzzyfind ->
later(function()
local pick = require('mini.pick')
local extra = require('mini.extra')
nmap_leader('ff', pick.builtin.files,                        '[f]ind in [f]iles' )
nmap_leader('fb', pick.builtin.buffers,                      '[f]ind in open [b]uffers' )
nmap_leader('fg', pick.builtin.grep_live,                    '[f]ind in [g]rep file' )
nmap_leader('fh', pick.builtin.help,                         '[f]ind in [h]elp' )
nmap_leader('fH', extra.pickers.hl_groups,                   '[f]ind in [H]ighlight groups' )
nmap_leader('fl', '<Cmd>Pick buf_lines scope="current"<CR>', '[f]ind in buffer [l]ines' )
nmap_leader('fL', '<Cmd>Pick buf_lines scope="all"<CR>',     '[f]ind in all buffer [l]ines' )
end)
-- <- 

-- g is for [g]it ->
local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
nmap_leader('gc', '<cmd>Git commit<cr>',        '[g]it [c]ommit' )
nmap_leader('ga', '<cmd>Git diff --cached<cr>', '[g]it [a]dd' )
-- nmap_leader('gA', '<Cmd>Git diff --cached -- %<CR>',              'Added diff buffer')
-- nmap_leader('gc', '<Cmd>Git commit<CR>',                          'Commit')
-- nmap_leader('gC', '<Cmd>Git commit --amend<CR>',                  'Commit amend')
-- nmap_leader('gd', '<Cmd>Git diff<CR>',                            'Diff')
-- nmap_leader('gD', '<Cmd>Git diff -- %<CR>',                       'Diff buffer')
-- nmap_leader('gg', '<Cmd>lua Config.open_lazygit()<CR>',           'Git tab')
-- nmap_leader('gl', '<Cmd>' .. git_log_cmd .. '<CR>',               'Log')
-- nmap_leader('gL', '<Cmd>' .. git_log_cmd .. ' --follow -- %<CR>', 'Log buffer')
-- nmap_leader('go', '<Cmd>lua MiniDiff.toggle_overlay()<CR>',       'Toggle overlay')
-- nmap_leader('gs', '<Cmd>lua MiniGit.show_at_cursor()<CR>',        'Show at cursor')

-- <- 

-- L is for [L]ua
nmap_leader('Ls', function() vim.cmd.source('%') print('Sourced file') end,                              '[L]ua [s]ource file' )
nmap_leader('Lc', function() vim.cmd.runtime{ '*.lua', bang = true} print('Sourced ~/.config/nvim') end, '[L]ua source [c]onfig' )

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

-- also enable expanding with tab for faster typing
map({'i','s'}, '<tab>', function()
if luasnip.expand_or_locally_jumpable() then
luasnip.expand_or_jump()
end
end, { silent = true })
end)
-- <-
