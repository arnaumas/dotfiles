{ pkgs, ... }: {
  imports = [
    ./core.nix
    ./zsh
    ./tmux
    ./fzf
    ./rg
    ./bat
  ];

  home.packages = [ pkgs.fd ];
}
