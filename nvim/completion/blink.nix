{ palette, ... }:
{
  plugins.blink-cmp = {
    enable = true;
    settings = {
      snippets.preset = "luasnip";

      completion.menu.auto_show.__raw = "function(_, items) return #items <= 5 end";

      keymap = {
        preset = "none";
        "<C-j>" = [ "select_next" "fallback" ];
        "<C-k>" = [ "select_prev" "fallback" ];
        "<C-y>" = [ "select_and_accept" "fallback" ];
        "<C-e>" = [ "cancel" "fallback" ];
        "<C-x>" = [ "show" "fallback" ];
      };
    };
  };

  colors.groups = {
    BlinkCmpMenu.link = "UiSurface";
    BlinkCmpMenuBorder.link = "UiSurfaceMuted";
    BlinkCmpMenuSelection.link = "UiSelected";
    BlinkCmpLabelMatch = {
      fg = palette.yellow;
      bold = true;
    };
    BlinkCmpLabelDeprecated.link = "UiMuted";
    BlinkCmpKind.link = "UiMuted";
    BlinkCmpDoc.link = "UiSurface";
    BlinkCmpDocBorder.link = "UiSurfaceMuted";
  };
}
