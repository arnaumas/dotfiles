-- Plugin configuration. Plugins themselves are installed/loaded in init.lua via
-- vim.pack.add (which runs first), so every setup() call here can be eager.

-- mini.ai -->
require('mini.ai').setup()
-- <--
-- mini.surround -->
require('mini.surround').setup({silent = true})
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
-- fzf-lua -->
local fzf_lua = require('fzf-lua')
fzf_lua.setup({})
fzf_lua.register_ui_select()
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
icons.mock_nvim_web_devicons()   -- route lualine's icon lookups through mini.icons
-- <--
-- mini.notify -->
local notify = require('mini.notify')
local win_config = function()
	local has_statusline = vim.o.laststatus > 0
	local pad = vim.o.cmdheight + (has_statusline and 1 or 0)
	return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad }
end
-- lsp_progress off: lualine owns the LSP loading indicator (see lualine block).
-- mini.notify stays as the general vim.notify backend.
notify.setup({ window = { config = win_config, winblend = 0 }, lsp_progress = { enable = false } })
vim.notify = notify.make_notify()
-- <--
-- lualine -->
-- sections reference colorscheme groups by name (colors defined in colors/ansi.lua),
-- so no slot numbers live here. Mode block (a) is a per-mode StlMode* group; b/c
-- inherit StatusLine.
local theme = {
	normal   = { a = 'StlModeNormal',   b = 'StatusLine', c = 'StatusLine' },
	insert   = { a = 'StlModeInsert',   b = 'StatusLine', c = 'StatusLine' },
	visual   = { a = 'StlModeVisual',   b = 'StatusLine', c = 'StatusLine' },
	replace  = { a = 'StlModeReplace',  b = 'StatusLine', c = 'StatusLine' },
	command  = { a = 'StlModeCommand',  b = 'StatusLine', c = 'StatusLine' },
	terminal = { a = 'StlModeTerminal', b = 'StatusLine', c = 'StatusLine' },
	inactive = { a = 'StatusLineNC',    b = 'StatusLineNC', c = 'StatusLineNC' },
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = theme,
    component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    always_show_tabline = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      buffers = 1000,
      winbar = 1000,
      refresh_time = 16, -- ~60fps
      events = {
        'WinEnter',
        'BufEnter',
        'BufWritePost',
        'SessionLoadPost',
        'FileChangedShellPost',
        'VimResized',
        'Filetype',
        'CursorMoved',
        'CursorMovedI',
        'ModeChanged',
      },
    }
  },
  sections = {
		lualine_a = {
			{ 'mode', fmt = function(s) return (s:gsub('(%a)%a*', '%1')) end }
		},
    lualine_b = {},
    lualine_c = {
			{
				'buffers',
				mode = 0,
				show_filename_only = false,
				buffers_color = {
					active   = 'StlTabActive',
					inactive = 'StlTabInactive',
				},
				symbols = {
					modified = ' [+]',
					alterante_file = '#',
					directory = '/',
				}
			}
		},
    lualine_x = {},
    lualine_y = {
			{
				'diagnostics',
				symbols = {
					error = '\u{f015a} %#StatusLine#', warn = '\u{f002a} %#StatusLine#',
					info  = '\u{f02fd} %#StatusLine#', hint = '\u{f0336} %#StatusLine#',
				},
				diagnostics_color = {
					error = 'DiagnosticError', warn = 'DiagnosticWarn',
					info  = 'DiagnosticInfo',  hint = 'DiagnosticHint',
				}
			},
			{ 'branch', icon = '\u{e725}' },
			'filetype'
		},
		lualine_z = {'location'}
	},
  extensions = {}
}
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
