{ p, ... }:
{
  programs.kitty = {
    settings = {
      tab_bar_edge = "bottom";
      tab_bar_align = "left";
      tab_bar_margin_width = "10";
      tab_bar_margin_height = "4 0";
      tab_bar_style = "separator";
      tab_separator = ''""'';
      tab_bar_min_tabs = 1;
      tab_title_template = ''" {index}: {title}{' Z' if layout_name == 'stack' else '''} "'';
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
    };

    colors = {
      active_tab_foreground = p.uiFg;
      active_tab_background = p.uiBg;
      inactive_tab_foreground = p.dimUiFg;
      inactive_tab_background = p.uiDimBg;
      tab_bar_background = p.uiDimBg;
    };
  };
}
