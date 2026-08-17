{
	files."after/ftplugin/tex.lua" = {
		localOpts.cursorlineopt = "screenline";
		keymaps = [
			{ mode = "n"; key = "o"; action = "g$a<cr><esc>"; }
			# { mode = [ "n" "o" "v" ]; key = "j"; action = "gj"; options = { silent = true; buffer = true; }; }
			# { mode = [ "n" "o" "v" ]; key = "k"; action = "gk"; options = { silent = true; buffer = true; }; }
			# { mode = [ "n" "o" "v" ]; key = "0"; action = "g0"; options = { silent = true; buffer = true; }; }
			# { mode = [ "n" "o" "v" ]; key = "$"; action = "g$"; options = { silent = true; buffer = true; }; }
			# { mode = "o"; key = "_"; action = "g_"; options = { silent = true; buffer = true; }; }
		];
	};
}
