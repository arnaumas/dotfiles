{
  programs.wezterm = {
    keys = [
      {
        key = "Enter";
        mods = "LEADER";
        action = "ActivateCopyMode";
      }
    ];
    settings.key_tables = {
      copy_mode = [
        {
          key = "/";
          mods = "NONE";
          action.Search = "CurrentSelectionOrEmptyString";
        }
        {
          key = "n";
          mods = "NONE";
          action.Multiple = [
            { CopyMode = "NextMatch"; }
            { CopyMode = "ClearSelectionMode"; }
          ];
        }
        {
          key = "N";
          mods = "SHIFT";
          action.Multiple = [
            { CopyMode = "PriorMatch"; }
            { CopyMode = "ClearSelectionMode"; }
          ];
        }
        {
          key = "p";
          mods = "CTRL";
          action.CopyMode.MoveBackwardZoneOfType = "Input";
        }
        {
          key = "n";
          mods = "CTRL";
          action.CopyMode.MoveForwardZoneOfType = "Input";
        }
        {
          key = "Enter";
          mods = "NONE";
          action = "Nop";
        }
        {
          key = "Escape";
          mods = "NONE";
          action.CopyMode = "ClearPattern";
        }
      ];
      search_mode = [
        {
          key = "Enter";
          mods = "NONE";
          action.Multiple = [
            { CopyMode = "ClearSelectionMode"; }
            { CopyMode = "AcceptPattern"; }
          ];
        }
        {
          key = "Escape";
          mods = "NONE";
          action.Multiple = [
            { CopyMode = "ClearPattern"; }
            { CopyMode = "ClearSelectionMode"; }
            { CopyMode = "AcceptPattern"; }
          ];
        }
      ];
    };
    colors = {
      copy_mode_inactive_highlight_fg.Color = "yellow";
      copy_mode_inactive_highlight_bg.Color = "uiBg";
      copy_mode_active_highlight_fg.Color = "yellow";
      copy_mode_active_highlight_bg.Color = "yellowBg";
    };
    extraConfig = "require('key-tables')(config)";
  };
  xdg.configFile."wezterm/key-tables.lua".source = ./key-tables.lua;
}
