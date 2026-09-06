{ lib, config, ... }:
{
  home.file = {
    ".cache/zsh/.keep".text = "";
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

    # everything irreducibly imperative (custom widgets, zle hooks, zstyles,
    # functions). mkAfter so it runs after hm's compinit + plugin sourcing, so
    # our keybinds (e.g. Tab) win over fzf-tab's own.
    initContent = lib.mkAfter ''
      			# aliases -->
      			mkd() {
      				mkdir -pv -- "$1" && cd -- "$1"
      			}
      			# <--

      			# keybinds: free these for terminal navigation -->
      			bindkey -r ^J
      			bindkey -r ^K
      			bindkey -r ^L
      			bindkey -r ^H
      			# <--
      		'';
  };

  imports = [
    ./prompt
    ./completion
    ./syntax.nix
    ./history.nix
    ./input
  ];
}
