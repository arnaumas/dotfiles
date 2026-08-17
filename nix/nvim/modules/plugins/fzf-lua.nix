{
	# fuzzy finder. ported from plugin/20_plugins.lua fzf-lua block + the
	# [f]uzzyfind keymaps in plugin/11_keymaps.lua.
	plugins.fzf-lua = {
		enable = true;
		settings = { };
	};

	# register_ui_select() has no nixvim option; wire it directly. VERIFY.
	extraConfigLua = ''
		require('fzf-lua').register_ui_select()
	'';

	keymaps = [
		{ mode = "n"; key = "<leader>ff"; action.__raw = "require('fzf-lua').files"; options.desc = "[f]ind in [f]iles"; }
		{ mode = "n"; key = "<leader>fb"; action.__raw = "require('fzf-lua').buffers"; options.desc = "[f]ind in open [b]uffers"; }
		{ mode = "n"; key = "<leader>fg"; action.__raw = "require('fzf-lua').live_grep"; options.desc = "[f]ind in [g]rep"; }
		{ mode = "n"; key = "<leader>fh"; action.__raw = "require('fzf-lua').help_tags"; options.desc = "[f]ind in [h]elp"; }
		{ mode = "n"; key = "<leader>fH"; action.__raw = "require('fzf-lua').highlights"; options.desc = "[f]ind in [H]ighlight groups"; }
		{ mode = "n"; key = "<leader>fl"; action.__raw = "require('fzf-lua').blines"; options.desc = "[f]ind in buffer [l]ines"; }
		{ mode = "n"; key = "<leader>fL"; action.__raw = "require('fzf-lua').lines"; options.desc = "[f]ind in all buffer [l]ines"; }
	];
}
