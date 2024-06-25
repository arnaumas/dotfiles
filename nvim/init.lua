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

-- configure nord colorscheme
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "nord",
	callback = function()
		vim.cmd.highlight({ "Search", "guibg=#81a1c1" })
		vim.cmd.highlight({ "CurSearch", "guifg=#2e3440", "guibg=#Ebcb8b" })
		vim.cmd.highlight({ "IncSearch", "guifg=#2e3440", "guibg=#Ebcb8b" })
		vim.cmd.highlight({ "Comment", "guifg=#b8bec7" })
	end,
	desc = "override highlight colors for search hits and comments",
})
vim.g.nord_disable_background = true
require('nord').set()

-- configure luasnip
local ls = require("luasnip")
vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true})

require("luasnip.loaders.from_lua").load({paths = "~/.config/nvim/luasnip/"})
