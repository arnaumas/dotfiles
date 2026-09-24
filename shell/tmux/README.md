# tmux

`programs.tmux` module. Prefix `C-b`, vi keys, base index 1, `tmux-256color`, no `escapeTime`,
`sensibleOnTop` off. Main config is the verbatim `tmux.conf`.

Used for genuine persistence, typically ssh: WezTerm owns local tabs and splits, so tmux keeps no
split/window binds. The status bar is a right-aligned `host:session` in bold blue; the bar turns
blueBg while the prefix is held. `set-clipboard on` lets OSC 52 from apps reach the clipboard.

## Tree

```
default.nix     programs.tmux options + extraConfig = tmux.conf
tmux.conf       verbatim tmux config (binds, styling, options)
```

nvim ↔ pane navigation lives in `wezterm/splits/` and no longer involves tmux.
