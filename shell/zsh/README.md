# zsh

`programs.zsh` module generating `.zshenv`/`.zprofile`/`.zshrc` from typed options. Split across
sub-modules; each contributes a `lib.mkAfter` `initContent` fragment so it runs after home-manager's
compinit + plugin sourcing (needed so custom keybinds win over fzf-tab's).

## Tree

```
default.nix       enable, dotDir = ~/.config/zsh, autocd, `...`/`....` dir aliases;
                  initContent: mkd() cd-helper, unbind ^H/^J/^K/^L for pane nav; imports the rest;
                  ensures ~/.cache/zsh exists
history.nix       10M-line history at $XDG_CACHE_HOME/zsh/history, no sharing/dedup;
                  up/down-line-or-beginning-search bound to arrow keys
completion/
  default.nix     autosuggestion (fg=7, unique_completion strategy, async);
                  compinit into $XDG_CACHE_HOME/zsh; sources completion.zsh
  completion.zsh  completion zstyles / menu behavior
syntax.nix        zsh-syntax-highlighting (main + brackets); ANSI slot styles
                  (commands=4, strings=2, comment=3, path=underline, brackets greyed)
vi.nix            vi keymap (viins default, KEYTIMEOUT=1); beam/block cursor switching per mode;
                  j/k history search in vicmd; ^e edit-command-line (wrapped to export
                  ZLE_NAMES = aliases + functions for the zle nvim); delete-key binds
prompt/
  default.nix     pure-prompt (fpath from pkgs.pure-prompt); prompt symbols (> / <), git arrows;
                  clear alias resets NEW_LINE_BEFORE_PROMPT
  prompt.zsh      pure prompt tweaks / async glue
```

## Notes

- XDG-first: caches under `$XDG_CACHE_HOME`, `ZDOTDIR = ~/.config/zsh`.
- Plugins are **nix-managed, flake-locked** (no plugin manager): autosuggestion + syntax-highlighting
  via first-class HM options, fzf-tab via `programs.zsh.plugins` (declared in `shell/fzf.nix`), pure
  from `pkgs.pure-prompt`.
- `^H/^J/^K/^L` are freed in `default.nix` so tmux/nvim pane navigation can claim them.
- The `refs` module (`~/home/refs`) appends a `refs()` fzf picker to `initContent` via `mkAfter`.
