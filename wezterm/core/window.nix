{
  programs.wezterm = {
    settings = {
      window_close_confirmation = "NeverPrompt";
      window_decorations = "RESIZE";
      window_padding = {
        left = "0.5cell";
        right = "0";
        bottom = "0";
      };
    };
    extraConfig = "require('window')(config.window_padding)";
  };

  xdg.configFile."wezterm/window.lua".source = ./window.lua;
}
