{
	# ported from plugin/12_autocmds.lua
	autoGroups = {
		highlight-yank = { clear = true; };
		restore_cursor = { clear = true; };
	};

	autoCmd = [
		{
			event = [ "TextYankPost" ];
			group = "highlight-yank";
			desc = "Highlight when yanking (copying) text";
			callback.__raw = "function() vim.highlight.on_yank() end";
		}
		{
			event = [ "VimLeave" ];
			group = "restore_cursor";
			pattern = "*";
			desc = "Restore cursor to pipe after exiting neovim";
			callback.__raw = ''function() os.execute [[ echo -ne "\e[6 q" ]] end'';
		}
	];
}
