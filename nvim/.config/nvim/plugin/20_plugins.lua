local add, now, later = MiniDeps.add, MiniDeps.now, MiniDeps.later

-- colorschemes -->
add('sainnhe/edge')
-- <--

-- mini plugins
add({ source = 'echasnovski/mini.nvim', checkout = 'stable' })
-- mini.ai -->
later(function() require('mini.ai').setup() end)
-- <--
-- mini.surround -->
later(function() require('mini.surround').setup({silent = true}) end)
-- <--
-- mini.extra -->
later(function() require('mini.extra').setup() end)
-- <--
-- mini.files -->
require('mini.files').setup({
	options = { use_as_default_explorer = true },
	content = { filter = function(fs_entry) return fs_entry.name ~= '.DS_Store' end }  
})
-- <--
-- mini.git -->
later(function() require('mini.git').setup() end)
-- <--
-- mini.pick -->
later(function()
	require('mini.pick').setup()
	vim.ui.select = MiniPick.ui_select
end)
-- <--

-- mini.icons -->
local icons = require('mini.icons')
icons.setup({
	default = {
		file = { glyph = '󰈔' }
	},
	file = {
		['init.lua'] = { glyph = '󰢱', hl = 'MiniIconsAzure' },
	},
	extension = {
		toml = { glyph = '󰈔' }
	}
})
-- <--
-- mini.notify -->
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
-- <--
-- mini.statusline -->
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
-- <--
-- mini.tabline -->
require('mini.tabline').setup()
-- <--

-- LuaSnip -->
add({ source = 'L3MON4D3/LuaSnip', checkout = 'stable' })
later(function()
	require('luasnip.loaders.from_lua').lazy_load({paths = '~/.config/nvim/snippets/'})
	require('luasnip').setup({
		cut_selection_keys = { '<C-l>', '<tab>' },
		enable_autosnippets = true,
		update_events = 'TextChanged, TextChangedI'
	})
end)
-- <--

-- vimtex -->
add({ source = 'lervag/vimtex' })
now(function()
	vim.g.vimtex_imaps_leader = '.'
	vim.g.vimtex_view_method = 'sioyek'
	vim.g.vimtex_view_sioyek_exe = '/Applications/sioyek.app/Contents/MacOS/sioyek'
	-- vim.g.vimtex_view_skim_sync = 1
	-- vim.g.vimtex_view_skim_activate = 1
	vim.g.vimtex_quickfix_open_on_warning = 0
	vim.g.vimtex_fold_enabled = 1
end)
-- <--

-- disabled plugins
-- vim-pencil -->
-- add({ source = 'preservim/vim-pencil' })

-- <--
-- noice (disabled) -->
-- add({
	-- source = 'folke/noice.nvim',
	-- depends = { 'MunifTanjim/nui.nvim' }
-- })
-- later(function() require('noice').setup() end)
-- <--
