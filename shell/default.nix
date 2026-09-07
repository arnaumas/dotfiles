{ pkgs, ... }: {
  imports = [
    ./core.nix
    ./zsh
    ./tmux
    ./bat
    ./fzf
    ./rg
  ];

  home.packages = [ pkgs.fd ];
}
