{ lib, config, ... }:
{
  imports = [
    ../core
    ../editing/core.nix
    ../ui/core.nix
    ../lang/zsh
    ./highlights.nix
  ];

  opts = {
    laststatus = lib.mkForce 0;
    number = lib.mkForce false;
    relativenumber = lib.mkForce false;
    signcolumn = lib.mkForce "no";
    foldcolumn = lib.mkForce "0";
    numberwidth = 1;
    statuscolumn = "%#ZlePrompt#%{v:virtnum == 0 ? '> ' : '  '}";
  };
  
  files."after/ftplugin/zsh.lua".keymaps = [
    {
      mode = "n";
      key = "q";
      action = "<cmd>wq<cr>";
      options = {
        buffer = true;
        silent = true;
      };
    }
  ];

  plugins.treesitter = {
    enable = true;
    grammarPackages = [ config.plugins.treesitter.package.builtGrammars.zsh ];
    settings = {
      indent.enable = true;
      highlight.enable = true;
    };
  };
}
