{ lib, config, ... }:
{
  options.colors.extraLua = lib.mkOption {
    type = lib.types.lines;
    default = "";
    description = "Highlight-group lua appended to colors/ansi.lua. Runs after the "
      + "prelude, so the palette locals and hl/link helpers are in scope.";
  };

  config = {
    colorscheme = "ansi";
    extraFiles."colors/ansi.lua".text =
      builtins.readFile ./highlights.lua + "\n" + config.colors.extraLua;
  };
}
