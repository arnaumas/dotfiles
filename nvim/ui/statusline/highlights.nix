# lualine statusline highlights.
{
  lib,
  palette,
  ...
}:
{
  colors.groups =
    let
      modes = {
        Normal = palette.magenta;
        Insert = palette.blue;
        Visual = palette.red;
        Replace = palette.yellow;
        Command = palette.green;
        Terminal = palette.cyan;
      };
    in
    lib.mkMerge [
      (lib.mapAttrs' (
        mode: color:
        lib.nameValuePair "StlMode${mode}" {
          fg = palette.dim_bg;
          bg = color;
          bold = true;
        }
      ) modes)
      {
        StlDiagnosticError.fg = palette.red;
        StlDiagnosticWarn.fg = palette.yellow;
        StlDiagnosticInfo.fg = palette.blue;
        StlDiagnosticHint.fg = palette.cyan;
        StlRecording = {
          fg = palette.blue;
          bg = palette.blue_bg;
        };
        StlTabActive.link = "UiSelected";
        StlTabInactive.link = "UiSurfaceMuted";
      }
    ];
}
