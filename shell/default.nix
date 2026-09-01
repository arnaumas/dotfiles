{ pkgs, ... }: {
  imports = [
    ./core.nix
    ./zsh
    ./tmux
    ./bat
    ./fzf.nix
    ./rg.nix
  ];

  home.packages = [ pkgs.fd ];
}
