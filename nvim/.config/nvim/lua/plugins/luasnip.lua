return {
	'L3MON4D3/LuaSnip',
	enable_autosnippets = true, 
	store_selection_keys = '<C-l>',

	config = function()
		require('luasnip.loaders.from_lua').lazy_load({paths = '~/.config/nvim/snippets/'})
	end,
}
