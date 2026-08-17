{
	plugins.oil = {
		enable = true;
		settings = {
			default_file_explorer = true;
			view_options = {
				show_hidden = true;
				is_always_hidden.__raw = "function(name, _) return name == '.DS_Store' end";
			};
			win_options.cursorline = true;
			float = {
				border = [ " " " " "" "" "" "" "" " " ];
				max_width = 50;
				max_height = 10;
				win_options.winhighlight = "Normal:NormalFloat,CursorLine:OilCursorLine";
				override.__raw = ''
					function(conf)
						conf.row = 1
						conf.col = 1
						return conf
					end
				'';
			};
			confirmation.border = "none";
			progress.border = "none";
			keymaps_help.border = "none";
		};
	};

	keymaps = [
		{ mode = "n"; key = "<leader>ef"; action.__raw = "function() require('oil').open_float() end"; options.desc = "[e]xplore [f]ile directory"; }
		{ mode = "n"; key = "<leader>ed"; action.__raw = "function() require('oil').open_float('/Users/arnau/dotfiles') end"; options.desc = "[e]xplore [d]otfiles"; }
		{ mode = "n"; key = "<leader>en"; action.__raw = "function() require('oil').open_float('/Users/arnau/dotfiles/nvim/.config/nvim') end"; options.desc = "[e]xplore [n]eovim config"; }
		{ mode = "n"; key = "<leader>ez"; action.__raw = "function() require('oil').open_float('/Users/arnau/dotfiles/zsh/.config/zsh') end"; options.desc = "[e]xplore [z]sh config"; }
	];
}
