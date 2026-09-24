# wezterm

`programs.wezterm` module. Leader `C-a` (`C-a C-a` sends a literal one), leader `r` reloads. Typed
settings plus lua dropped in via `xdg.configFile` (`window`, `splits`, `bar`, generated `colors`),
and the nvim side of pane navigation. On darwin the package is `emptyDirectory`, since the app
comes from the cask, and zsh integration is off.

Colours are set by role name, never hex: `programs.wezterm.colors` takes roles from the `theme`
arg and `core/theme.nix` resolves them per appearance, writing `colors.lua` for the lua files.

## Tree

```
core/
  default.nix     enable, darwin package + zsh-integration split; imports the rest
  keys.nix        programs.wezterm.keys option (key/mods/action), leader C-a, leader r reload
  theme.nix       role-named colours resolved per appearance; writes colors.lua
  window.nix      padding, RESIZE decorations, no close confirmation
  window.lua      leftover vertical pixels go to the top, so the last row meets the tab bar
splits/
  navigation.nix  leader s/v split, c/x close, h/j/k/l focus, w/W cycle, i/u resize, z zoom;
                  C-h/j/k/l emit nav-* events
  splits.lua      nav-* handler plus the pane-grow/shrink resize logic
  nvim.nix        nvim side of C-hjkl, loaded when wezterm is enabled
  nvim-nav.lua    _G.pane_nav(dir): wincmd, then hop panes at a window edge
  ui.nix          split divider colour, underline thickness, inactive panes undimmed
tabs/
  navigation.nix  leader t new tab, n/p cycle, 1-9 jump, 0 last, q close
  bar.nix         plain tab bar at the bottom, tab/session/prefix colours
  bar.lua         tab titles (index, title or cwd, zoom flag), workspace and prefix marker
```

## nvim nav

- **wezterm side**: `C-h/j/k/l` emit `nav-<key>`. `splits.lua` walks the pane's process tree; when
  it finds vim/nvim/view/fzf/tmux it sends the key into the pane, otherwise it activates the pane
  in that direction.
- **nvim side**: `nvim.nix` binds `<C-h/j/k/l>` (normal + terminal modes) to `_G.pane_nav(dir)` via
  `extraConfigLuaPre` + `keymaps` (`lib.mkAfter`, so it overrides `nvim/core/default.nix`'s plain
  `<C-w>` window maps). It runs the `wincmd`; if the window did not change and `$WEZTERM_PANE` is
  set, it shells out to `wezterm cli activate-pane-direction`.
- fzf buffers get the raw `<C-hjkl>` fed back, so fzf keeps its own bindings.
- Net effect: `<C-hjkl>` crosses nvim splits and wezterm panes as one grid, no plugin.
