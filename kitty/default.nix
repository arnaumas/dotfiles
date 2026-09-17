{ theme, pkgs, lib, ... }:

let
  light = theme.light;
  dark = theme.dark;

  renderTheme = t: lib.concatStringsSep "\n" [
    "foreground ${t.uiFg}"
    "background ${t.termBg}"
    "selection_background ${t.uiBg}"
    "selection_foreground ${t.uiFg}"
    "active_tab_foreground ${t.uiFg}"
    "active_tab_background ${t.uiBg}"
    "inactive_tab_foreground ${t.dimUiFg}"
    "inactive_tab_background ${t.uiDimBg}"
    "tab_bar_background ${t.uiDimBg}"
    "active_border_color ${t.grey}"
    "inactive_border_color ${t.grey}"
    "color0 ${t.black or t.white}"
    "color1 ${t.red}"
    "color2 ${t.green}"
    "color3 ${t.yellow}"
    "color4 ${t.blue}"
    "color5 ${t.magenta}"
    "color6 ${t.cyan}"
    "color7 ${t.grey}"
    "color8 ${t.blackBg or t.whiteBg}"
    "color9 ${t.redBg}"
    "color10 ${t.greenBg}"
    "color11 ${t.yellowBg}"
    "color12 ${t.blueBg}"
    "color13 ${t.magentaBg}"
    "color14 ${t.cyanBg}"
    "color15 ${t.greyBg}"
    "cursor none"
  ] + "\n";
  
in {
  programs.kitty = {
    enable = true;

    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.kitty;

    settings = {
      font_size = 12;
      disable_ligatures = "always"; # TODO check font_features
      cursor_shape = "beam";
      confirm_os_window_close = 0;
      window_margin_width = "2 3 4";
      hide_window_decorations = "titlebar-only";
      enabled_layouts = "splits,stack";
      draw_minimal_borders = "yes";
      window_border_width = "1pt";
      tab_bar_edge = "bottom";
      tab_bar_align = "left";
      tab_bar_style = "separator";
      tab_separator = "";
      tab_title_template = " {index}: {title}{' Z' if layout_name == 'stack' else ''} ";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
    };
    
    keybindings = {
      "ctrl+a>t" = "new_tab_with_cwd";
      "ctrl+a>n" = "next_tab";
      "ctrl+a>p" = "previous_tab";
      "ctrl+a>s" = "launch --location=hsplit --cwd=current";
      "ctrl+a>v" = "launch --location=vsplit --cwd=current";
      "ctrl+a>x" = "close_window";
      "ctrl+a>q" = "close_tab";
      "ctrl+a>z" = "toggle_layout stack";
      "ctrl+a>plus" = "resize_window taller 3";
      "ctrl+a>minus" = "resize_window shorter 3";
      "ctrl+a>enter" = "show_scrollback";
    };
  };

  xdg.configFile = {
    "kitty/light-theme.auto.conf".text = renderTheme light;
    "kitty/dark-theme.auto.conf".text = renderTheme dark;
    "kitty/no-preference-theme.auto.conf".text = renderTheme light;

    "kitty/quick-access-terminal.conf".text = ''
      edge center
      lines 20
      columns 100
    '';
  };
}
