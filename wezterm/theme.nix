{ theme, lib, ... }:
let
  scheme = p: {
    foreground = p.uiFg;
    background = p.termBg;
    selection_fg = p.uiFg;
    selection_bg = p.uiBg;
    ansi = [ (p.black or p.white) p.red p.green p.yellow p.blue p.magenta p.cyan p.grey ];
    brights = [ (p.blackBg or p.whiteBg) p.redBg p.greenBg p.yellowBg p.blueBg p.magentaBg p.cyanBg p.greyBg ];
  };
in {
  programs.wezterm = {
    colorSchemes = {
      dotfiles-light = scheme theme.light;
      dotfiles-dark = scheme theme.dark;
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
