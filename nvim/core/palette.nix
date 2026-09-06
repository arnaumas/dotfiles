# The ANSI palette, as nix data.
#
# `slots` is the color -> ANSI-slot mapping: a property of the terminal palette,
# shared by every terminal consumer (see the colorscheme notes in CLAUDE.md).
# The semantic roles below (accent, selection) are nvim's own, layered on top.
#
# Injected as the `palette` arg into every module via `_module.args`, so each
# concern writes `fg = palette.red` instead of a magic slot number.
#
# Phase A keeps this self-contained in nvim. A later phase lifts `slots` to
# dotfiles/lib and threads it in via the `theme` channel; the roles stay here.
{ ... }:
let
  slots = {
    fg = 0;
    dim_fg = 7;
    bg = 8;
    dim_bg = 15;
    red = 1;
    green = 2;
    yellow = 3;
    blue = 4;
    magenta = 5;
    cyan = 6;
    red_bg = 9;
    green_bg = 10;
    yellow_bg = 11;
    blue_bg = 12;
    magenta_bg = 13;
    cyan_bg = 14;
  };
in
{
  _module.args.palette = slots // {
    accent = slots.green;
    accent_bg = slots.green_bg;
    selection_fg = slots.fg;
    selection_bg = slots.bg;
  };
}
