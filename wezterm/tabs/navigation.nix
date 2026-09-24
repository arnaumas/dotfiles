let
  lead = key: action: {
    inherit key action;
    mods = "LEADER";
  };
  
in {
  programs.wezterm.keys = [
    (lead "t" { SpawnTab = "CurrentPaneDomain"; })
    (lead "n" { ActivateTabRelative = 1; })
    (lead "p" { ActivateTabRelative = -1; })
    (lead "q" { CloseCurrentTab.confirm = false; })
  ];
}
