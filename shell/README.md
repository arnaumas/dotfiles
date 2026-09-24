# shell

Bundle module for the interactive shell environment. `default.nix` imports the sub-modules and adds
`fd` to `home.packages`.

## Tree

```
default.nix     imports core/readline/less/zsh/tmux/fzf/rg/bat; installs fd
core.nix        env vars + aliases + PATH bit:
                  EDITOR/VISUAL=nvim, MANPAGER=nvim +Man!, CLAUDE_CONFIG_DIR, LS_COLORS,
                  PYTHON_HISTORY -> $XDG_STATE_HOME, GNUPGHOME;
                  aliases (cp/mv/rm interactive, vim=nvim, ll); home.sessionPath += ~/.local/bin
less.nix        LESSHISTFILE -> $XDG_STATE_HOME/less/history
readline/
  default.nix   installs rlwrap; INPUTRC/EDITRC -> ~/.config/readline,
                RLWRAP_HOME -> $XDG_STATE_HOME/rlwrap; base inputrc + editrc (both vi mode)
  nix/          nix-repl() rlwrap wrapper (readline+inputrc, nix-words completion); nix-repl inputrc block
  python/       PYTHONSTARTUP + PYTHON_BASIC_REPL; python inputrc block
fzf.nix         wraps fzf with ANSI base16 colors + default opts (height, reverse, no scrollbar…);
                registers fzf-tab as a zsh plugin (pkgs.zsh-fzf-tab)
rg.nix          wraps ripgrep with ANSI --colors (match=yellow, path=blue, …)
bat/
  default.nix   programs.bat, theme = ansi16 (custom), style = header,snip
  ansi16.tmTheme 16-slot ANSI bat theme
zsh/            see shell/zsh/README.md
tmux/           see shell/tmux/README.md
```

## Notes

- fzf and rg are **package wrappers** (symlinkJoin + wrapProgram) so the ANSI flags apply to every
  invocation, interactive or scripted.
- All color choices map onto ANSI slots 0–15, inheriting hex from the running terminal (ghostty),
  so the shell UIs match the editor. Source of truth: `~/home/themes/edge-vague.nix`.
- Two line-editor configs: `inputrc` (GNU readline: rlwrap-wrapped `nix-repl`, python) and `editrc`
  (libedit: bare `nix repl`, sqlite3, lldb). REPL histories are kept off `$HOME` via `RLWRAP_HOME`
  and `PYTHON_HISTORY`.
