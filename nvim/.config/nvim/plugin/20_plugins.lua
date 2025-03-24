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
	notify.setup()
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

-- mini.extra ->
add({ source = 'echasnovski/mini.extra', checkout = 'stable' })
later(function() require('mini.extra').setup() end)
-- <-

-- noice (disabled) ->
-- add({
	-- source = 'folke/noice.nvim',
	-- depends = { 'MunifTanjim/nui.nvim' }
-- })
-- later(function() require('noice').setup() end)
-- <-
