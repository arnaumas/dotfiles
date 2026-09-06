{
  imports = [ ./highlights.nix ];

  files."after/ftplugin/zsh.lua".localOpts = {
    wrap = false;
    sidescrolloff = 12;
  };
}
