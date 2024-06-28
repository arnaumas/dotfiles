-- load lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- load plugins
require("lazy").setup({
	spec = {
		"L3MON4D3/LuaSnip",
		"shaunsingh/nord.nvim",
		"lervag/vimtex"
	},

	install = { colorscheme = { "nord"} },
	ui = {
		icons = {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

vim.opt.number = true

-- configure nord colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "nord",
	callback = function()
		vim.cmd.highlight({ "Search", "guibg=#81a1c1" })
		vim.cmd.highlight({ "CurSearch", "guifg=#2e3440", "guibg=#Ebcb8b" })
		vim.cmd.highlight({ "IncSearch", "guifg=#2e3440", "guibg=#Ebcb8b" })
		vim.cmd.highlight({ "Comment", "guifg=#b8bec7" })
		vim.cmd.highlight({ "LineNr", "guifg=#b8bec7" })
	end,
	desc = "override highlight colors for search hits and comments",
})
vim.g.nord_disable_background = true
require('nord').set()

-- configure luasnip
vim.cmd[[
" Use Tab to expand and jump through snippets
imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
smap <silent><expr> <Tab> luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : '<Tab>'

" Use Shift-Tab to jump backwards through snippets
imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
]]

-- lua version of the previous key remaps
-- local ls = require("luasnip")
-- vim.keymap.set({"i"}, "<Tab>", function()
	-- if ls.expand_or_jumpable() then
		-- ls.expand_or_jump()
	-- else 
		-- return vim.api.nvim_replace_termcodes('<TAB>', true, false, true)
	-- end
-- end, {silent = true})
--
-- vim.keymap.set({"s"}, "<Tab>", function()
-- 	if ls.jumpable(1) then
-- 		ls.jump(1)
-- 	end
-- end, {silent = true})
--
-- vim.keymap.set({"i", "s"}, "<S-Tab>", function()
-- 	if ls. jumpable(-1) then
-- 		ls.jump(-1)
-- 	end
-- end, {silent = true})
--
-- vim.keymap.set({"i", "s"}, "<C-E>", function()
-- 	if ls.choice_active() then
-- 		ls.change_choice(1)
-- 	end
-- end, {silent = true})

require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/luasnip/"})
