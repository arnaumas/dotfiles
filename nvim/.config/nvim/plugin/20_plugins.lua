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
icons.mock_nvim_web_devicons()   -- route lualine's icon lookups through mini.icons (no nvim-web-devicons dep)
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
-- Replaces mini.statusline + mini.tabline + mini.notify's LSP progress.
-- termguicolors is OFF (see 10_options): the theme uses raw ANSI slot numbers
-- (0-15) so it stays colorscheme-agnostic and matches edge-ansi everywhere.
-- lualine passes numeric fg/bg straight through to ctermfg/ctermbg.
local slot = {
	grey = 8, red = 1, green = 2, yellow = 3, blue = 4, magenta = 5, cyan = 6, white = 15, text = 0,
}
-- section text: dark fg (slot 0) on the faint surface (slot 15), like the old
-- mini sections; mode (a) is white text on a per-mode hue, bold.
local function modeline(bg)
	return {
		a = { fg = slot.white, bg = bg, gui = 'bold' },
		b = { fg = slot.text,  bg = slot.white },
		c = { fg = slot.text,  bg = slot.white },
	}
end
local edge_theme = {
	normal   = modeline(slot.magenta),
	insert   = modeline(slot.blue),
	visual   = modeline(slot.red),
	replace  = modeline(slot.yellow),
	command  = modeline(slot.green),
	terminal = modeline(slot.cyan),
	-- inactive: filename + filetype only, all on slot 15 so it doesn't read as
	-- body text; muted grey fg to signal the window isn't focused.
	inactive = {
		a = { fg = slot.grey, bg = slot.white },
		b = { fg = slot.grey, bg = slot.white },
		c = { fg = slot.grey, bg = slot.white },
	},
}

-- git branch from mini.git's per-buffer summary string (no fugitive/gitsigns dep).
local function git_branch()
	local s = vim.b.minigit_summary_string
	return (s and s ~= '') and s or ''
end

-- LSP: attached server names, with a braille spinner + progress title while a
-- server is loading (vim.lsp.status, Neovim 0.10+). The LspProgress autocmd
-- below refreshes lualine so the spinner animates.
local spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' }
local function lsp_status()
	local clients = vim.lsp.get_clients({ bufnr = 0 })
	if #clients == 0 then return '' end
	local names = {}
	for _, c in ipairs(clients) do names[#names + 1] = c.name end
	local label = table.concat(names, ',')
	local progress = vim.lsp.status()
	if progress ~= '' then
		local frame = spinner[(math.floor(vim.uv.hrtime() / 1e8) % #spinner) + 1]
		return frame .. ' ' .. progress
	end
	return ' ' .. label
end

require('lualine').setup({
	options = {
		theme = edge_theme,
		icons_enabled = true,
		globalstatus = false,             -- per-window statuslines (keeps inactive line)
		section_separators = '',          -- flat, minimal: no powerline arrows
		component_separators = '',
	},
	sections = {
		lualine_a = { 'mode' },
		lualine_b = { git_branch, 'diagnostics' },
		lualine_c = { 'filename' },
		lualine_x = { lsp_status, 'filetype' },
		lualine_y = { 'encoding', 'fileformat' },
		lualine_z = { function() return '%2l:%-2v' end },
	},
	inactive_sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { 'filename' },
		lualine_x = { 'filetype' },
		lualine_y = {},
		lualine_z = {},
	},
	tabline = {
		lualine_a = { 'tabs' },           -- tab list, replaces mini.tabline
	},
})

-- animate the LSP spinner while a server reports progress
vim.api.nvim_create_autocmd('LspProgress', {
	group = vim.api.nvim_create_augroup('lualine-lsp-progress', { clear = true }),
	callback = function() require('lualine').refresh() end,
})
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
