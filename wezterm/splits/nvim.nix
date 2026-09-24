{ config, lib, ... }:
{
  programs.nixvim = lib.mkIf config.programs.wezterm.enable {
    extraConfigLuaPre = builtins.readFile ./nvim-nav.lua;
    keymaps = lib.mkAfter [
      {
        mode = [ "n" "t" ];
        key = "<C-h>";
        action = "<cmd>lua pane_nav('h')<cr>";
        options.desc = "focus/pane left";
      }
      {
        mode = [ "n" "t" ];
        key = "<C-j>";
        action = "<cmd>lua pane_nav('j')<cr>";
        options.desc = "focus/pane below";
      }
      {
        mode = [ "n" "t" ];
        key = "<C-k>";
        action = "<cmd>lua pane_nav('k')<cr>";
        options.desc = "focus/pane above";
      }
      {
        mode = [ "n" "t" ];
        key = "<C-l>";
        action = "<cmd>lua pane_nav('l')<cr>";
        options.desc = "focus/pane right";
      }
    ];
  };
}
