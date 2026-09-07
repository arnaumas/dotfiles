{ pkgs, ... }:
{
  home.packages = [ pkgs.pi-coding-agent ];
  home.file.".pi/agent/themes/edge.json".source = ./edge.json;
}
