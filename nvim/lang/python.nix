{ pkgs, ... }:
{
  extraPackages = [ pkgs.pyright ];

  lsp.servers.pyright = {
    enable = true;
    config = {
      cmd = [ "pyright-langserver" "--stdio" ];
      filetypes = [ "python" ];
      root_markers = [ "pyproject.toml" "setup.py" "setup.cfg" "requirements.txt" ".git" ];
    };
  };

  files."after/ftplugin/python.lua".localOpts = {
    expandtab = true;
    shiftwidth = 4;
    tabstop = 4;
  };
}
