{ config, pkgs, lib, ... }:
{
  imports = [
    ./nix
    ./python
  ];

  home.packages = [ pkgs.rlwrap ];

  home.sessionVariables = {
    INPUTRC = "${config.xdg.configHome}/readline/inputrc";
    EDITRC = "${config.xdg.configHome}/readline/editrc";
    RLWRAP_HOME = "${config.xdg.stateHome}/rlwrap";
  };

  xdg.configFile."readline/inputrc".text = lib.mkBefore ''
    set editing-mode vi
    set keyseq-timeout 10
    set completion-ignore-case on
    set show-all-if-ambiguous on
    set colored-completion-prefix on
    set colored-stats on
    set bell-style none
  '';

  xdg.configFile."readline/editrc".text = lib.mkBefore ''
    # vi editing in every libedit repl (python basic repl, sqlite3, lldb, ...)
    bind -v

    # history
    history size 10000
    history unique 1

    # command-mode keys: j/k history, / ? search, n/N repeat
    bind -a k ed-prev-history
    bind -a j ed-next-history
    bind -a / vi-search-prev
    bind -a ? vi-search-next
    bind -a n vi-repeat-search-next
    bind -a N vi-repeat-search-prev
  '';
}
