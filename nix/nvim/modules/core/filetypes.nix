let
	# lua and zsh share the same marker-fold config. FoldText is a global helper
	# (re)defined when the ftplugin sources, matching the original files.
	foldFt = {
		opts = {
			foldmethod = "marker";
			foldmarker = " -->,<--";
			wrap = false;
			sidescrolloff = 12;
		};
	};
in
{
	files = {
		"after/ftplugin/lua.lua" = foldFt;
		"after/ftplugin/zsh.lua" = foldFt;
		"after/ftplugin/help.lua" = {
			keymaps = [
				{ mode = "n"; key = "q"; action = "<cmd>helpclose<cr>"; options = { buffer = true; silent = true; }; }
				{ mode = "n"; key = "<cr>"; action = "<C-]>"; options.buffer = true; }
				{ mode = "n"; key = "<bs>"; action = "<C-t>"; options.buffer = true; }
			];
		};

		"after/ftplugin/tex.lua" = {
			opts = {
				cursorlineopt = "screenline";
				ruler = false;
			};
			keymaps = [
				# global in the original (no buffer scope) -- kept faithful.
				{ mode = "n"; key = "o"; action = "g$a<cr><esc>"; }
				# { mode = [ "n" "o" "v" ]; key = "j"; action = "gj"; options = { silent = true; buffer = true; }; }
				# { mode = [ "n" "o" "v" ]; key = "k"; action = "gk"; options = { silent = true; buffer = true; }; }
				# { mode = [ "n" "o" "v" ]; key = "0"; action = "g0"; options = { silent = true; buffer = true; }; }
				# { mode = [ "n" "o" "v" ]; key = "$"; action = "g$"; options = { silent = true; buffer = true; }; }
				# { mode = "o"; key = "_"; action = "g_"; options = { silent = true; buffer = true; }; }
			];
		};
	};
}
