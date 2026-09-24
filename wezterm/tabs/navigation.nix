let
  lead = key: action: {
    inherit key action;
    mods = "LEADER";
  };
  
  digit = n: lead (toString n) { ActivateTab = n - 1; };
  
in {
  programs.wezterm.keys = [
    (lead "t" { SpawnTab = "CurrentPaneDomain"; })
    (lead "n" { ActivateTabRelative = 1; })
    (lead "p" { ActivateTabRelative = -1; })
    (lead "q" { CloseCurrentTab.confirm = false; })
    (lead "0" { ActivateTab = -1; })
  ]
  ++ map digit [ 1 2 3 4 5 6 7 8 9 ];
}
