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
fzf_lua.setup({
	winopts = {
		border = "none",
		preview = { border = "border-top", title = false, scrollbar = false }
	},
	fzf_colors = {
		['fg']     = { 'fg', 'FzfLuaNormal' },
		['bg']     = { 'bg', 'FzfLuaNormal' },
		['query']  = { 'fg', 'FzfLuaNormal' },
		['fg+']    = { 'fg', 'PmenuSel', 'bold' },
		['bg+']    = { 'bg', 'PmenuSel' },
		['gutter'] = { 'bg', 'FzfLuaNormal' },
		['header'] = { 'fg', 'Pmenu' }
	},
	hls = {
		normal         = 'FzfLuaNormal',
		border         = 'FzfLuaNormal',
		preview_normal = 'FzfLuaNormal',
		preview_border = 'FzfLuaPreviewBorder',
		buf_flag_cur   = "PMenu"
	},
	files      = { prompt = 'files > ' },
	buffers    = {
		prompt = 'buffers > ',
		headers = false,
		winopts = {
			row = 1,
			col = 0,
			height = 5,
			width = 0.3,
			preview = { hidden = true },
		},
		fzf_opts = { ['--layout'] = 'default' },
	},
	grep       = { prompt = 'grep > ' },   -- covers live_grep
	helptags   = { prompt = 'help > ' },
	highlights = { prompt = 'highlights > ' },
	blines     = { prompt = 'lines > ' },
	lines      = { prompt = 'all lines > ' },
})
fzf_lua.register_ui_select(nil,true)

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
	return { anchor = 'SE', col = vim.o.columns, row = vim.o.lines - pad, border = 'none' }
end

-- '● │ msg' in the popup, '● │ HH:MM:SS │ msg' in the history buffer.
-- The dot is colored per level; mini highlights whole lines only, so the dot
-- gets a higher-priority ephemeral extmark (see the decoration provider below).
local dot, dot_ns = '●', vim.api.nvim_create_namespace('mini-notify-dot')
local dot_hl = { ERROR = 'DiagnosticError', WARN = 'DiagnosticWarn', INFO = 'DiagnosticInfo',
	DEBUG = 'DiagnosticHint', TRACE = 'DiagnosticOk', OFF = 'MiniNotifyNormal' }
local line_hl, in_history = {}, false
local format = function(notif)
	local msg = notif.msg
	if in_history then
		msg = vim.fn.strftime('%H:%M:%S', math.floor(notif.ts_update)) .. ' ' .. msg
	end
	local res = ' ' .. dot .. ' ' .. msg
	line_hl[vim.split(res, '\n')[1]] = dot_hl[notif.level] or dot_hl.INFO
	return res
end
vim.api.nvim_set_decoration_provider(dot_ns, {
	on_win = function(_, _, buf) return vim.bo[buf].filetype:find('^mininotify') ~= nil end,
	on_line = function(_, _, buf, row)
		local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1]
		local hl = line ~= nil and line_hl[line] or nil
		if hl == nil then return end
		vim.api.nvim_buf_set_extmark(buf, dot_ns, row, 1,
			{ end_col = 1 + #dot, hl_group = hl, priority = 5000, ephemeral = true })
	end,
})

-- lsp_progress off: lualine owns the LSP loading indicator (see lualine block).
-- mini.notify stays as the general vim.notify backend.
notify.setup({
	content = { format = format },
	window = { config = win_config, winblend = 0 },
	lsp_progress = { enable = false },
})
-- Levels keep the body at normal float colors; the level shows in the dot.
local plain = { hl_group = 'MiniNotifyNormal' }
vim.notify = notify.make_notify({
	ERROR = plain, WARN = plain, INFO = plain, DEBUG = plain, TRACE = plain, OFF = plain,
})
-- show_history() reuses `format`, hence the flag (it is synchronous).
vim.api.nvim_create_user_command('Notifications', function()
	in_history = true
	notify.show_history()
	in_history = false
end, { desc = 'mini.notify history' })
-- <--
-- lualine -->
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
				buffers_color = {
					active   = 'StlTabActive',
					inactive = 'StlTabInactive',
				},
				symbols = {
					modified = ' [+]',
					alternate_file = '',
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

-- Compile messages as notifications. vimtex's own echo for these four is muted
-- by g:vimtex_log_ignore in init.lua; :VimtexLog still records everything.
local function tex_notify(msg, level)
	vim.notify('VimTeX: ' .. msg, level)
end

local tex_events = {
	VimtexEventCompileStarted = function() tex_notify('compiling ' .. vim.b.vimtex.base, vim.log.levels.INFO) end,
	VimtexEventCompileSuccess = function() tex_notify('compiled ' .. vim.b.vimtex.base, vim.log.levels.INFO) end,
	VimtexEventCompileStopped = function() tex_notify('compiler stopped', vim.log.levels.WARN) end,
	VimtexEventCompileFailed = function()
		tex_notify(('failed (%d qf entries)'):format(#vim.fn.getqflist()), vim.log.levels.ERROR)
	end,
}

for pattern, callback in pairs(tex_events) do
	vim.api.nvim_create_autocmd('User', { pattern = pattern, callback = callback })
end
-- <--

-- disabled plugins
-- vim-pencil -->
-- (add 'https://github.com/preservim/vim-pencil' to vim.pack.add in init.lua)
-- <--
-- noice (disabled) -->
-- add to init.lua: { src = 'https://github.com/folke/noice.nvim' } + nui.nvim,
-- then: require('noice').setup()
-- <--
