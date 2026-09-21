let
  lead = key: action: {
    inherit key action;
    mods = "LEADER";
  };
  close = {
    CloseCurrentPane.confirm = false;
  };
  nav = key: {
    inherit key;
    mods = "CTRL";
    action.EmitEvent = "nav-${key}";
  };
in
{
  programs.wezterm = {
    keys = [
      (lead "s" { SplitPane.direction = "Down"; })
      (lead "v" { SplitPane.direction = "Right"; })
      (lead "c" close)
      (lead "q" close)
      (lead "h" { ActivatePaneDirection = "Left"; })
      (lead "j" { ActivatePaneDirection = "Down"; })
      (lead "k" { ActivatePaneDirection = "Up"; })
      (lead "l" { ActivatePaneDirection = "Right"; })
      (lead "w" { ActivatePaneDirection = "Next"; })
      (lead "W" { ActivatePaneDirection = "Prev"; })
      (lead "i" { EmitEvent = "pane-grow"; })
      (lead "u" { EmitEvent = "pane-shrink"; })
      (lead "r" { RotatePanes = "Clockwise"; })
      (lead "R" { RotatePanes = "CounterClockwise"; })
      (lead "z" "TogglePaneZoomState")
    ]
    ++ map nav [ "h" "j" "k" "l" ];
    extraConfig = "require 'splits'";
  };

  xdg.configFile."wezterm/splits.lua".source = ./splits.lua;
}
