local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

add('sainnhe/edge')

-- mini.statusline ->
add({ source = 'echasnovski/mini.statusline', checkout = 'stable' })
later(function() 
	local statusline = require('mini.statusline')
	statusline.setup({
		content = {
			inactive = function()
				local filename = statusline.section_filename({ trunc_width = 120 })
				local fileinfo = statusline.section_fileinfo({ trunc_width = 120 })
				return statusline.combine_groups({
					{ hl = 'MiniStatuslineInactive', strings = { filename } },
					'%=',
					{ hl = 'MiniStatuslineFileinfo', strings = { fileinfo } }
				})
			end,
		}
	})
	statusline.section_location = function() return '%2l:%-2v' end
end)
-- <-

-- mini.icons ->
add({ source = 'echasnovski/mini.icons', checkout = 'stable' })
later(function() require('mini.icons').setup() end)
-- <-

-- mini.notify ->
add({ source = 'echasnovski/mini.notify', checkout = 'stable' })
later(function()
	local notify = require('mini.notify')
	local win_config = function()
    local has_statusline = vim.o.laststatus > 0
    local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
    return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
  end
  notify.setup({ window = { config = win_config, winblend = 0 } })
	vim.notify = notify.make_notify()
end)
-- <-

-- mini.git ->
add({ source = 'echasnovski/mini-git', checkout = 'stable' })
later(function() require('mini.git').setup() end)
-- <-

-- mini.ai ->
add({ source = 'echasnovski/mini.ai', checkout = 'stable' })
later(function() require('mini.ai').setup() end)
-- <-

-- mini.surround ->
add({ source = 'echasnovski/mini.surround', checkout = 'stable' })
later(function() require('mini.surround').setup({silent = true}) end)
-- <-

-- mini.pick ->
add({ 
	source = 'echasnovski/mini.pick',
	checkout = 'stable',
	-- depends = { 'echanovski/mini.extra' } 
})
later(function()
	require('mini.pick').setup()
	vim.ui.select = MiniPick.ui_select
end)
-- <-

-- mini.files ->
add({ 
	source = 'echasnovski/mini.files',
	checkout = 'stable',
})
later(function()
	require('mini.files').setup()
end)
-- <-

-- mini.extra ->
add({ source = 'echasnovski/mini.extra', checkout = 'stable' })
later(function() require('mini.extra').setup() end)
-- <-

-- LuaSnip ->
add({ source = 'L3MON4D3/LuaSnip', checkout = 'stable' })
later(function()
	require('luasnip.loaders.from_lua').lazy_load({paths = '~/.config/nvim/snippets/'})
	require('luasnip').setup({
		cut_selection_keys = '<C-l>',
		enable_autosnippets = true,
		update_events = 'TextChanged, TextChangedI'
	})
end)
-- <-

-- vimtex ->
add({ source = 'lervag/vimtex' })
now(function()
	vim.g.vimtex_imaps_leader = '.'
	vim.g.vimtex_view_method = 'skim'
	vim.g.vimtex_view_skim_sync = 1
	vim.g.vimtex_view_skim_activate = 1
	vim.g.vimtex_quickfix_open_on_warning = 0
	vim.g.vimtex_fold_enabled = 1
end)
-- <-

-- noice (disabled) ->
-- add({
	-- source = 'folke/noice.nvim',
	-- depends = { 'MunifTanjim/nui.nvim' }
-- })
-- later(function() require('noice').setup() end)
-- <-
