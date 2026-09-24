{ pkgs, ... }:

{
  imports = [
    ./keys.nix
    ./theme.nix
    ./window.nix
  ];

  programs.wezterm =
    let isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
    in {
      enable = true;
      package = if isDarwin then pkgs.emptyDirectory else pkgs.wezterm;
      enableZshIntegration = !isDarwin;
    };
}
