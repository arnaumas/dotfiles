{
	plugins.luasnip = {
		enable = true;
		fromLua = [ { paths = ./.; } ];
		settings = {
			cut_selection_keys = "<Tab>";
			enable_autosnippets = true;
			update_events = "TextChanged, TextChangedI";
		};
	};

	keymaps = [
		{
			mode = [ "i" "s" ];
			key = "<C-l>";
			options.silent = true;
			action.__raw = ''
				function()
					local luasnip = require('luasnip')
					if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
				end
			'';
		}
		{
			mode = [ "i" "s" ];
			key = "<C-h>";
			options.silent = true;
			action.__raw = ''
				function()
					local luasnip = require('luasnip')
					if luasnip.locally_jumpable(-1) then luasnip.jump(-1) end
				end
			'';
		}
		{
			mode = [ "i" "s" ];
			key = "<tab>";
			options.silent = true;
			action.__raw = ''
				function()
					local luasnip = require('luasnip')
					if luasnip.expand_or_locally_jumpable() then luasnip.expand_or_jump() end
				end
			'';
		}
	];
}
