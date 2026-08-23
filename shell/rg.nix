{ pkgs, lib, ... }:
let
  arguments = [
    "--colors=match:none"
    "--colors=match:fg:yellow"
    "--colors=match:style:bold"
    "--colors=path:none"
    "--colors=path:fg:blue"
    "--colors=line:none"
    "--colors=line:fg:white"
    "--colors=column:none"
    "--colors=column:fg:black"
    "--colors=column:style:intense"
  ];

  ripgrep = pkgs.symlinkJoin {
    name = "ripgrep-wrapped";
    paths = [ pkgs.ripgrep ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      			wrapProgram $out/bin/rg \
      				--add-flags "${lib.concatStringsSep " " arguments}"
      		'';
    inherit (pkgs.ripgrep) version;
    meta.mainProgram = "rg";
  };
in
{
  home.packages = [ ripgrep ];
}
