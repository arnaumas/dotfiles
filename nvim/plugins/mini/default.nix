{
	plugins.mini = {
		enable = true;
		modules = {
			ai = { };
			surround = { silent = true; };
			git = { };
			notify = {
				content.format.__raw = "_M.notify.format";
				window = {
					config = { anchor = "NE"; border = "none"; };
					winblend = 0;
				};
				lsp_progress.enable = true;
			};
		};
		luaConfig.pre = builtins.readFile ./notify-defs.lua;
		luaConfig.post = builtins.readFile ./notify-wire.lua;
	};

	userCommands.Notifications = {
		command.__raw = ''
			function()
				in_history = true
				require('mini.notify').show_history()
				in_history = false
			end
		'';
		desc = "mini.notify history";
	};

	keymaps = [
		{ mode = "n"; key = "<leader>gc"; action = "<cmd>Git commit<cr>"; options.desc = "[g]it [c]ommit"; }
		{ mode = "n"; key = "<leader>ga"; action = "<cmd>Git diff --cached<cr>"; options.desc = "[g]it [a]dd"; }
	];
}
