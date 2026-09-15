{ config, pkgs, lib, ... }:
{
  imports = [
    ./nix
    ./python
  ];

  home.packages = [ pkgs.rlwrap ];

  home.sessionVariables.INPUTRC = "${config.xdg.configHome}/readline/inputrc";

  xdg.configFile."readline/inputrc".text = lib.mkBefore ''
    set editing-mode vi
    set keyseq-timeout 10
    set completion-ignore-case on
    set show-all-if-ambiguous on
    set colored-completion-prefix on
    set colored-stats on
    set bell-style none
  '';
}
