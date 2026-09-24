{ lib, ... }:
let
  seq = "[27;9;111~";
  sub = file: builtins.replaceStrings [ "@seq@" ] [ seq ] (builtins.readFile file);
  
in {
  programs.wezterm = {
    keys = [
      {
        key = "o";
        mods = "LEADER";
        action.EmitEvent = "last-output";
      }
    ];
    extraConfig = "require 'last-output'";
  };

  programs.zsh.initContent = lib.mkAfter (sub ./last-output.zsh);

  xdg.configFile."wezterm/last-output.lua".text = sub ./last-output.lua;
}
