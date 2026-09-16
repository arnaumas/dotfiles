{ theme, pkgs, lib, ... }:

let
  light = theme.light;
  dark = theme.dark;

  renderTheme = t: lib.concatStringsSep "\n" [
    "foreground ${t.uiFg}"
    "background ${t.termBg}"
    "selection_background ${t.uiBg}"
    "selection_foreground ${light.uiFg}"
    "cursor ${t.uiFg}"
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
  ] + "\n";
in
{
  programs.kitty = {
    enable = true;

    package = if pkgs.stdenv.hostPlatform.isDarwin then null else pkgs.kitty;

    settings = {
      font_size = 12;
      disable_ligatures = "always"; # TODO check font_features
      cursor_shape = "beam";
      cursor_text_color = "background";
      confirm_os_window_close = 0;
      window_padding_width = "10 4 2 4";
      hide_window_decorations = "titlebar-only";
      enabled_layouts = "splits,stack";
      draw_minimal_borders = "yes";
      window_border_width = "1pt";
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
