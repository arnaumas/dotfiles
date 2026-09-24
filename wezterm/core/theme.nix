{ theme, lib, config, ... }:
let
  roles = lib.attrNames (theme.light // theme.dark);
  render = p: lib.mapAttrs (_: role: p.${role}) config.programs.wezterm.colors;
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
    type = lib.types.attrsOf (lib.types.enum roles);
    default = { };
  };

  config.programs.wezterm = {
    colors = {
      foreground = "uiFg";
      background = "termBg";
      selection_fg = "uiFg";
      selection_bg = "uiBg";
    };
    colorSchemes = lib.mapAttrs (_: p: base p // render p) {
      dotfiles-light = theme.light;
      dotfiles-dark = theme.dark;
    };
    settings = {
      color_scheme = lib.generators.mkLuaInline ''
        wezterm.gui and wezterm.gui.get_appearance():find 'Dark'
        and 'dotfiles-dark' or 'dotfiles-light'
      '';
      bold_brightens_ansi_colors = false;
      force_reverse_video_cursor = true;
    };
  };
}
