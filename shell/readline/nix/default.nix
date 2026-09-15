{ config, lib, ... }:
{
    programs.zsh.initContent = lib.mkAfter ''
      nix-repl() {
        if [[ -n $TMUX ]]; then
          tmux rename-window nix
          ( exec -a nix-repl rlwrap -a -C nix-repl -S ' ' \
              -f . -f ${config.xdg.configHome}/readline/nix-words nix repl )
          tmux setw -u automatic-rename
        else
          ( exec -a nix-repl rlwrap -a -C nix-repl -S ' ' \
              -f . -f ${config.xdg.configHome}/readline/nix-words nix repl )
        fi
      }
    '';
    
  xdg.configFile."readline/nix-words".source = ./nix-words;

  xdg.configFile."readline/inputrc".text = lib.mkAfter ''
    $if nix-repl
    set show-mode-in-prompt on
    set vi-ins-mode-string "\1\e[6 q\e[0;34m\2nix >\1\e[0m\2"
    set vi-cmd-mode-string "\1\e[2 q\e[0;34m\2nix <\1\e[0m\2"
    $endif
  '';
}
