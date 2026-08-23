{ pkgs, ... }:
{
  extraPackages = [ pkgs.nixd ];

  lsp.servers.nixd = {
    enable = true;
    config = {
      cmd = [ "nixd" ];
      filetypes = [ "nix" ];
      root_markers = [ "flake.nix" ".git" ];
    };
  };
}
