{
  files."after/ftplugin/zsh.lua".localOpts = {
    wrap = false;
    sidescrolloff = 12;
  };

  colors.extraLua = builtins.readFile ./highlights.lua;
}
