# fzf-lua highlights.
{ palette, ... }:
{
  colors.groups = {
    FzfLuaNormal.link = "UiSurface";
    FzfLuaPreviewBorder.link = "UiSurfaceMuted";
    FzfLuaFzfPrompt.fg = palette.blue;
    FzfLuaFzfMatch = {
      fg = palette.yellow;
      bold = true;
    };
    FzfLuaFzfInput.bg = palette.blue_bg;
  };
}
