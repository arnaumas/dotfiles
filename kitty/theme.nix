{ theme, lib, config, ... }:
let
  literals = [ "none" ];
  p = lib.genAttrs (lib.attrNames (theme.dark // theme.light) ++ literals) (n: n);

  render = theme:
    let table = theme // lib.genAttrs literals (n: n);
    in lib.concatStringsSep "\n" (
        lib.mapAttrsToList (key: role: "${key} ${table.${role}}") config.programs.kitty.colors
      ) + "\n";
  
in {
  options.programs.kitty.colors = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    default = { };
  };

  config = {
    _module.args.p = p;

    programs.kitty.colors = {
      foreground = p.uiFg;
      background = p.termBg;
      selection_background = p.uiBg;
      selection_foreground = p.uiFg;
      color0 = p.uiFg;
      color1 = p.red;
      color2 = p.green;
      color3 = p.yellow;
      color4 = p.blue;
      color5 = p.magenta;
      color6 = p.cyan;
      color7 = p.grey;
      color8 = p.uiBg;
      color9 = p.redBg;
      color10 = p.greenBg;
      color11 = p.yellowBg;
      color12 = p.blueBg;
      color13 = p.magentaBg;
      color14 = p.cyanBg;
      color15 = p.greyBg;
    };

    xdg.configFile = {
      "kitty/light-theme.auto.conf".text = render theme.light;
      "kitty/dark-theme.auto.conf".text = render theme.dark;
      "kitty/no-preference-theme.auto.conf".text = render theme.light;
    };
  };
}
