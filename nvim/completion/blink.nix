{ palette, ... }:
{
  plugins.blink-cmp = {
    enable = true;
    settings = {
      snippets.preset = "luasnip";

      # automatically show blink menu if the suggestion is unique
      completion.menu.auto_show.__raw = ''
        function(_, items)
        	return #items <= 1
        end
      '';

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

  extraConfigLuaPost = ''
    do
    	local list = require("blink.cmp.completion.list")
    	local menu = require("blink.cmp.completion.windows.menu")
    	list.show_emitter:on(function(event)
    		if not menu.auto_show.enabled(event.context, event.items) then
    			menu.close()
    		end
    	end)
    end
  '';

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
