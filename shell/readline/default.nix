{ config, pkgs, ... }:
{
  home.packages = [ pkgs.rlwrap ];

  home.sessionVariables = {
    INPUTRC = "${config.xdg.configHome}/readline/inputrc";
    PYTHONSTARTUP = "${config.xdg.configHome}/python/startup.py";
  };

  xdg.configFile = {
    "readline/inputrc".source = ./inputrc;
    "readline/nix-words".source = ./nix-words;
    "python/startup.py".source = ./startup.py;
  };

  home.shellAliases.nix-repl =
    "rlwrap -a -f . -f ${config.xdg.configHome}/readline/nix-words -p'0;34' -S 'nix > ' nix repl";
}
