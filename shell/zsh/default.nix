{ lib, config, ... }:
{
  imports = [
    ./prompt
    ./completion
    ./syntax.nix
    ./history.nix
    ./input
  ];
  
  home.file = {
    ".cache/zsh/.keep".text = "";
    ".local/state/zsh/.keep".text = "";
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    autocd = true;
    shellGlobalAliases = {
      "..." = "../..";
      "...." = "../../..";
      "....." = "../../../..";
    };

    initContent = lib.mkAfter ''
      # aliases
      mkd() {
        mkdir -pv -- "$1" && cd -- "$1"
      }

      # keybinds: free these for terminal navigation
      bindkey -r ^J
      bindkey -r ^K
      bindkey -r ^L
      bindkey -r ^H
    '';
  };
}
