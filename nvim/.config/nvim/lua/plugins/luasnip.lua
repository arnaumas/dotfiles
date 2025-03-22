return {
	'L3MON4D3/LuaSnip',
	enable_autosnippets = true, 
	store_selection_keys = '<Tab>',

	config = function()
		require('luasnip.loaders.from_lua').lazy_load({paths = '~/.config/nvim/snippets/'})
	end,
}
