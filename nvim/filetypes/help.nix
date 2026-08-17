{
	files."after/ftplugin/help.lua".keymaps = [
		{ mode = "n"; key = "q"; action = "<cmd>helpclose<cr>"; options = { buffer = true; silent = true; }; }
		{ mode = "n"; key = "<cr>"; action = "<C-]>"; options.buffer = true; }
		{ mode = "n"; key = "<bs>"; action = "<C-t>"; options.buffer = true; }
	];
}
