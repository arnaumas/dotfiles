# tmux

`programs.tmux` module. Prefix `C-a`, vi keys, base index 1, `tmux-256color`, no `escapeTime`,
`sensibleOnTop` off. Main config is the verbatim `tmux.conf`; `nav.nix` adds seamless nvim ↔ pane
navigation.

## Tree

```
default.nix     programs.tmux options + extraConfig = tmux.conf; imports nav.nix
tmux.conf       verbatim tmux config (binds, styling, options)
nav.nix         seamless split/pane nav shared with nvim (only when both tmux + nixvim are enabled)
tmux-nav.lua    _G.tmux_nav(dir): wincmd, and at a window edge shell out to `tmux select-pane`
```

## nav.nix — how it works

- **nvim side**: binds `<C-h/j/k/l>` (normal + terminal modes) to `tmux_nav(...)`. Loaded via
  `programs.nixvim.extraConfigLuaPre` + `keymaps` (`lib.mkAfter`, so it overrides `core/default.nix`'s
  plain `<C-w>` window maps).
- **tmux side**: `bind -n C-h/j/k/l` with an `is_vim` process check (`ps` on the pane tty matches
  vim/nvim/view/fzf). Inside vim it forwards the key; otherwise it does `select-pane -L/D/U/R`.
- Net effect: `<C-hjkl>` moves between nvim splits and tmux panes as one seamless grid, no plugin.
