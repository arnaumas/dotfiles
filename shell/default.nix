{ pkgs, ... }: {
  imports = [
    ./core.nix
    ./zsh
    ./tmux
    ./bat
    ./fzf
    ./rg.nix
  ];

  home.packages = [ pkgs.fd ];
}
