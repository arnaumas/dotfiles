{ p, ... }:
{
  programs.kitty = {
    settings = {
      font_size = 12;
      disable_ligatures = "always";
      cursor_shape = "beam";
      confirm_os_window_close = 0;
      window_padding_width = "2 1 0";
      padding_fill_strategy = "neighboring_cell";
      hide_window_decorations = "titlebar-only";
      enabled_layouts = "splits,stack";
      draw_minimal_borders = "yes";
      window_border_width = "1px";
    };

    colors = {
      cursor = p.none;
      active_border_color = p.none;
      inactive_border_color = p.grey;
    };
  };
}
