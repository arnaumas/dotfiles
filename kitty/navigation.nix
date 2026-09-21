{
  programs.kitty.keybindings = {
    "ctrl+a>t" = "new_tab_with_cwd";
    "ctrl+a>n" = "next_tab";
    "ctrl+a>p" = "previous_tab";
    "ctrl+a>s" = "launch --location=hsplit --cwd=current";
    "ctrl+a>v" = "launch --location=vsplit --cwd=current";
    "ctrl+a>x" = "close_window";
    "ctrl+a>q" = "close_tab";
    "ctrl+a>z" = "toggle_layout stack";
    "ctrl+a>plus" = "resize_window taller 3";
    "ctrl+a>minus" = "resize_window shorter 3";
    "ctrl+a>enter" = "show_scrollback";
  };
}
