{ pkgs, ... }: {
  imports = [
    ./core.nix
    ./less.nix
    ./zsh
    ./tmux
    ./fzf
    ./rg
    ./bat
  ];

  home.packages = [ pkgs.fd ];
}
