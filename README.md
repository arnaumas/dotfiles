# dotfiles

Personal dotfiles as a **home-manager module set** (no stow). Exposes `homeModules.default`
(the whole tree) and standalone `homeConfigurations` via `flake.nix`. Normally consumed by the
`~/home` composition (`~/home/flake.nix`), which adds `desktop-env`, `refs`, a `darwin` config, and
the `themes/` palette. Design bias: **lean and modular** — a purpose-built config with only what's
needed, split per concern, not a wholesale distro or plugin-manager framework (not anti-dependency).
The center of gravity is a Neovim environment for LaTeX writing. See `CLAUDE.md` for the full
rationale and `ROADMAP.md` for planned work.

## Wiring

`home.nix` imports `shell`, `claude`, `pi`, `git`, `ghostty`, `wezterm`, `svim`, `vim`; nvim is
wired via `programs.nixvim.imports = [ ./nvim ]`. The `theme` arg (hex palette) is passed in from
`~/home`.

Modules render config three ways: **typed program options** (`programs.zsh`, `programs.tmux`,
`programs.fzf`, `programs.bat`, `programs.ghostty`, `programs.nixvim`); **`xdg.configFile."<app>/…".source`**
for verbatim files without an HM module (`git`, `svim`, `vim`, `claude/`); and **`home.file` /
`home.packages`** for `$HOME` dotfiles and bare packages (`pi`, `fd`, wrapped `rg`).

## Packages (each has its own README)

| Package | What | README |
|---|---|---|
| `nvim/` | nixvim flake — the LaTeX-focused editor | [nvim/README.md](nvim/README.md) |
| `shell/` | zsh + tmux + fzf + rg + bat + core env | [shell/README.md](shell/README.md) |
| `shell/zsh/` | zsh config (prompt, completion, vi, syntax, history) | [shell/zsh/README.md](shell/zsh/README.md) |
| `shell/tmux/` | tmux config, for ssh and persistence | [shell/tmux/README.md](shell/tmux/README.md) |
| `git/` | git config + global ignore | [git/README.md](git/README.md) |
| `claude/` | Claude Code config, statusline, skills | [claude/README.md](claude/README.md) |
| `pi/` | pi coding agent + ANSI theme | [pi/README.md](pi/README.md) |
| `ghostty/` | ghostty terminal (typed opts + themes) | [ghostty/README.md](ghostty/README.md) |
| `wezterm/` | wezterm terminal: tabs, splits, nvim nav | [wezterm/README.md](wezterm/README.md) |

## Kept but minimal / unwired

- `svim/`, `vim/` — small verbatim rc files (`xdg.configFile`).
- `unused/` (aerospace, hammerspoon), `custom-layout.bundle` — kept, not imported.
- `theme.nix` — byte-for-byte duplicate of `~/home/themes/edge-vague.nix`, used only by this repo's
  standalone `homeConfigurations` (Phase 1 collapses it).

## Build / validate

- `nix flake check` — evaluates the module set + a headless zsh startup check + the nvim check.
- Format `.nix` with `nixfmt`; lint with `statix` / `deadnix`.
- Indentation: **hard tabs**, `shiftwidth=2` (global `opts` in `nvim/editing/default.nix`), except
  `*.nix` = 2 spaces (`expandtab` ftplugin in `nvim/lang/nix.nix`).
