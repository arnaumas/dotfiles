{ lib, ... }:
{
  programs.zsh.initContent = lib.mkAfter ''
    ${builtins.readFile ./lastout.zsh}
  '';
}
