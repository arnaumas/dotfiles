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

  files."after/ftplugin/nix.lua".localOpts.expandtab = true;
}
