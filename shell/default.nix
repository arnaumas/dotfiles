{ pkgs, ... }: {
  imports = [
    ./core.nix
    ./readline
    ./less.nix
    ./zsh
    ./tmux
    ./fzf
    ./rg
    ./bat
  ];

  home.packages = [ pkgs.fd ];
}
