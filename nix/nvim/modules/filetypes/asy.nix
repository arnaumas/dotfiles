{
	files."after/ftplugin/asy.lua" = {
		localOpts = {
			makeprg = "asy -o %:r %";
			errorformat = "%f: %l.%c: %m,%f: %l.%c: %tarning: %m";
		};
		extraConfigLuaPre = builtins.readFile ./asy.lua;
		keymaps = [
			{ mode = "n"; key = "<leader>ll"; action.__raw = "compile"; options = { buffer = true; silent = true; desc = "compile"; }; }
			{ mode = "n"; key = "<leader>lv"; action.__raw = "view"; options = { buffer = true; silent = true; desc = "view"; }; }
		];
	};
}
