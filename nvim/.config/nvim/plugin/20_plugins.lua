-- Plugin configuration. Plugins themselves are installed/loaded in init.lua via
-- vim.pack.add (which runs first), so every setup() call here can be eager.

-- mini.ai -->
require('mini.ai').setup()
-- <--
-- mini.surround -->
require('mini.surround').setup({silent = true})
-- <--
-- mini.extra -->
require('mini.extra').setup()
-- <--
-- mini.files -->
require('mini.files').setup({
	options = { use_as_default_explorer = true },
	content = { filter = function(fs_entry) return fs_entry.name ~= '.DS_Store' end }
})
-- <--
-- mini.git -->
require('mini.git').setup()
-- <--
-- mini.pick -->
require('mini.pick').setup()
vim.ui.select = MiniPick.ui_select
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
local notify = require('mini.notify')
local win_config = function()
	local has_statusline = vim.o.laststatus > 0
	local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
	return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
end
notify.setup({ window = { config = win_config, winblend = 0 } })
vim.notify = notify.make_notify()
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
require('luasnip.loaders.from_lua').lazy_load({paths = '~/.config/nvim/snippets/'})
require('luasnip').setup({
	cut_selection_keys = { '<C-l>', '<tab>' },
	enable_autosnippets = true,
	update_events = 'TextChanged, TextChangedI'
})
-- <--

-- blink.cmp -->
require('blink.cmp').setup({
	snippets = { preset = 'luasnip' },                       -- blink lists/expands your luasnip snippets
	sources = {
		default = { 'lsp', 'snippets', 'buffer', 'path' },

		-- LaTeX prose: only complete commands/refs/cites (LSP) + snippets.
		-- Dropping 'buffer' means typing prose words won't pop a menu;
		-- texlab returns nothing for plain words, so the menu only appears
		-- after '\' , '{', etc. -- the Overleaf-style behavior.
		per_filetype = {
			tex = { 'lsp', 'snippets' },
		},

		providers = {
			buffer = {
				min_keyword_length = 5,           -- don't suggest until 5+ chars typed
				-- Suppress previously-used words while inside comments/strings.
				enabled = function()
					local ok, node = pcall(vim.treesitter.get_node)
					if ok and node then
						local t = node:type()
						if t:find('comment') or t:find('string') then return false end
					end
					return true
				end,
			},
		},
	},
	signature = { enabled = true },                          -- param hints as you type
	-- Auto-downloads a prebuilt Rust matcher (no cargo); falls back to Lua + warning if it can't.
	fuzzy = { implementation = 'prefer_rust_with_warning' },
	completion = {
		documentation = { auto_show = false },                  -- docs only on demand (see <C-d>)
	},
	keymap = {
		preset = 'none',                                       -- Tab / C-l / C-h stay 100% LuaSnip
		['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
		['<C-n>']     = { 'select_next', 'fallback' },
		['<C-p>']     = { 'select_prev', 'fallback' },
		['<C-y>']     = { 'select_and_accept' },
		['<C-e>']     = { 'hide', 'fallback' },
		['<C-k>']     = { 'show_signature', 'hide_signature', 'fallback' },
	},
})
-- <--

-- vimtex -->
vim.g.vimtex_imaps_leader = '.'
vim.g.vimtex_view_method = 'sioyek'
vim.g.vimtex_view_sioyek_exe = '/Applications/sioyek.app/Contents/MacOS/sioyek'
-- vim.g.vimtex_view_skim_sync = 1
-- vim.g.vimtex_view_skim_activate = 1
vim.g.vimtex_quickfix_open_on_warning = 0
vim.g.vimtex_fold_enabled = 1
-- Treat \mathbb{R}, \mathcal{...}, \mathbf{...} etc. as ordinary commands
-- (\name blue + argument as plain math) instead of one concealed symbol token.
-- Only affects the math-symbol *conceal* feature, which is dormant at
-- conceallevel=0 anyway -- so no visual change, just consistent coloring.
vim.g.vimtex_syntax_conceal = vim.tbl_extend('force', vim.g.vimtex_syntax_conceal or {}, { math_symbols = 0 })
-- <--

-- disabled plugins
-- vim-pencil -->
-- (add 'https://github.com/preservim/vim-pencil' to vim.pack.add in init.lua)
-- <--
-- noice (disabled) -->
-- add to init.lua: { src = 'https://github.com/folke/noice.nvim' } + nui.nvim,
-- then: require('noice').setup()
-- <--
