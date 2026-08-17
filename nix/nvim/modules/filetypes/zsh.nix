{
	files."after/ftplugin/zsh.lua".localOpts = (import ./marker-fold.nix;) // {
		wrap = false;
		sidescrolloff = 12;
	};
}
