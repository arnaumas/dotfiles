let
  inactive = {
    bg_color = "uiDimBg";
    fg_color = "dimUiFg";
  };
  
in {
  programs.wezterm = {
    colors.tab_bar = {
      background = "uiDimBg";
      active_tab = {
        bg_color = "uiBg";
        fg_color = "uiFg";
      };
      inactive_tab = inactive;
      inactive_tab_hover = inactive;
    };
    colors.lua = {
      session = {
        fg = "uiDimBg";
        bg = "yellow";
      };
      prefix = "redBg";
    };
    
    settings = {
      use_fancy_tab_bar = false;
      tab_bar_at_bottom = true;
      show_new_tab_button_in_tab_bar = false;
      tab_max_width = 32;
    };
    extraConfig = "require 'bar'";
  };

  xdg.configFile."wezterm/bar.lua".source = ./bar.lua;
}
