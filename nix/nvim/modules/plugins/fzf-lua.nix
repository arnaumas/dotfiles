{
	plugins.fzf-lua = {
		enable = true;
		settings = {
		# TODO: figure out how to make title disappear
			winopts = {
				title = false;
				border = [ "" " " "" "" "" " " "" "" ];
				preview = { border = "border-top"; title = false; scrollbar = false; };
				treesitter = { fzf_colors = false; };
			};
			fzf_colors = {
				fg = [ "fg" "FzfLuaNormal" ];
				bg = [ "bg" "FzfLuaNormal" ];
				query = [ "fg" "FzfLuaNormal" ];
				"fg+" = [ "fg" "PmenuSel" "bold" ];
				"bg+" = [ "bg" "PmenuSel" ];
				gutter = [ "bg" "FzfLuaNormal" ];
				header = [ "fg" "Pmenu" ];
				info = [ "fg" "FzfLuaNormal" "dim" ];
			};
			hls = {
				normal = "FzfLuaNormal";
				border = "FzfLuaNormal";
				preview_normal = "FzfLuaNormal";
				preview_border = "FzfLuaPreviewBorder";
				buf_flag_cur = "PMenu";
			};
			files = { prompt = "files > "; };
			buffers = {
				prompt = "buffers > ";
				headers = false;
				winopts = {
					row = 1;
					col = 0;
					height = 5;
					width = 0.3;
					preview = { hidden = true; };
				};
				fzf_opts = { "--layout" = "default"; };
			};
			grep = { prompt = "grep > "; };
			helptags = { prompt = "help > "; };
			highlights = { prompt = "highlights > "; };
			blines = {
				prompt = "all buffers > ";
				winopts = { preview = { hidden = true; }; };
			};
			lines = {
				prompt = "buffer > ";
				winopts = { preview = { hidden = true; }; };
			};
		};
	};

	extraConfigLua = ''
		require('fzf-lua').register_ui_select(nil, true)
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
