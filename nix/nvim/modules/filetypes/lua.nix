{
	files."after/ftplugin/lua.lua".localOpts = (import ./marker-fold.nix;) // {
		wrap = false;
		sidescrolloff = 12;
	};
}
