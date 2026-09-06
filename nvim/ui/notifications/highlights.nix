# mini.notify highlights.
{ palette, ... }:
{
  colors.groups = {
    NtfError.fg = palette.red;
    NtfWarn.fg = palette.yellow;
    NtfInfo.fg = palette.blue;
    NtfHint.fg = palette.cyan;
    NtfOk.fg = palette.green;
  };
}
