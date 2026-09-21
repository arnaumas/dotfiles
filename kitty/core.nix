{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.kitty;
  };
}
