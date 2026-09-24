{ theme, lib, config, ... }:
let
  roles = lib.attrNames (theme.light // theme.dark);
  
  nest = n: if n == 0 then lib.types.enum roles else lib.types.either (lib.types.enum roles) (lib.types.attrsOf (nest (n -1)));
  resolve = p: v: if lib.isAttrs v then lib.mapAttrs (_: resolve p) v else p.${v};
  resolved = p: resolve p config.programs.wezterm.colors;
  scheme = p: removeAttrs (resolved p) [ "lua" ];
  exported = p: scheme p // (resolved p).lua or { };
  dark = "wezterm.gui and wezterm.gui.get_appearance():find 'Dark'";
  
  base = p: {
    ansi = [
      (p.black or p.white)
      p.red
      p.green
      p.yellow
      p.blue
      p.magenta
      p.cyan
      p.grey
    ];
    brights = [
      (p.blackBg or p.whiteBg)
      p.redBg
      p.greenBg
      p.yellowBg
      p.blueBg
      p.magentaBg
      p.cyanBg
      p.greyBg
    ];
  };
  
in {
  options.programs.wezterm.colors = lib.mkOption {
    type = lib.types.attrsOf (nest 2);
    default = { };
  };

  config.xdg.configFile."wezterm/colors.lua".text = ''
    local wezterm = require 'wezterm'
    local c = ${lib.generators.toLua { } {
      light = exported theme.light;
      dark = exported theme.dark;
    }}
    return ${dark} and c.dark or c.light
  '';

  config.programs.wezterm = {
    colors = {
      foreground = "uiFg";
      background = "termBg";
      selection_fg = "uiFg";
      selection_bg = "uiBg";
      cursor_border = "grey";
    };
    colorSchemes = lib.mapAttrs (_: p: base p // scheme p) {
      dotfiles-light = theme.light;
      dotfiles-dark = theme.dark;
    };
    settings = {
      color_scheme = lib.generators.mkLuaInline "${dark} and 'dotfiles-dark' or 'dotfiles-light'";
      bold_brightens_ansi_colors = false;
      force_reverse_video_cursor = true;
    };
  };
}
