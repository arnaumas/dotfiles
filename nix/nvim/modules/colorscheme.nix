{
	# terminal-anchored colorscheme. ansi.lua maps highlight groups to ANSI slot
	# NUMBERS (ctermfg/ctermbg), never hex; termguicolors is OFF (see options.nix).
	# kept verbatim for now; the later step splits its plugin groups (MiniFiles*,
	# BlinkCmp*, tex*, Stl*) into the owning plugin modules + a shared slot table.
	colorscheme = "ansi";
	extraFiles."colors/ansi.lua".source = ../colors/ansi.lua;
}
