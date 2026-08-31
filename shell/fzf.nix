{ pkgs, lib, ... }:
let
  colors = {
    "fg" = "-1";
    "list-fg" = "0";
    "bg" = "-1";
    "fg+" = "-1:bold";
    "bg+" = "8";
    "hl" = "3:bold";
    "hl+" = "3:bold";
    "query" = "-1:regular";
    "prompt" = "4:regular";
    "marker" = "3:bold";
    "gutter" = "-1";
    "pointer" = "4:regular";
    "preview-border" = "7";
  };

  colorFlag =
    "--color=base16,"
    + lib.concatStringsSep "," (lib.mapAttrsToList (name: value: "${name}:${value}") colors);

  defaultOpts = [
    colorFlag
    "--height=~8"
    "--layout=reverse"
    "--padding=0,0,0,1"
    "--border=none"
    "--pointer=''"
    "--marker='> '"
    "--cycle"
    "--no-scrollbar"
    "--no-info"
    "--no-separator"
    "--preview-border=line"
    "--preview-window=noinfo"
    "--bind=tab:toggle+down,enter:accept"
  ];

  fzf = pkgs.symlinkJoin {
    name = "fzf-wrapped";
    paths = [
      pkgs.fzf
      pkgs.fzf.man
    ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      			wrapProgram $out/bin/fzf \
      				--add-flags "${lib.concatStringsSep " " defaultOpts}"
      		'';
    inherit (pkgs.fzf) version;
    meta.mainProgram = "fzf";
  };

in
{
  programs.fzf = {
    enable = true;
    package = fzf;
    enableZshIntegration = true;
  };

  programs.zsh.plugins = [
    {
      name = "fzf-tab";
      src = pkgs.zsh-fzf-tab;
      file = "share/fzf-tab/fzf-tab.plugin.zsh";
    }
  ];
}
