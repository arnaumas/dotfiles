# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

This repo holds personal dotfiles, deployed with **GNU stow**. The primary goal is a
**lean, efficient Neovim environment for LaTeX writing**. The guiding bias throughout is
**minimal dependencies**: prefer built-in / first-party mechanisms over heavier abstractions
(e.g. Neovim's built-in `vim.pack` and LSP over plugin managers and `mason`, vendored-free zsh
plugins cloned on demand). Keep that bias when editing.

## Layout & deployment (stow)

Each top-level directory is a **stow package** whose internal tree mirrors its install target,
so `stow <pkg>` symlinks it into place from the repo root:

- Most packages use `<pkg>/.config/<pkg>/...` → `~/.config/<pkg>/...`.
- **zsh is the exception**: `zsh/.zshenv` stows to `~/.zshenv` (it must live in `$HOME` to set
  `ZDOTDIR=~/.config/zsh`); everything else under `zsh/.config/zsh/` follows the XDG layout.

When adding a config file, place it at the path it should occupy *relative to its install target*,
not where it's convenient.

**Actively used:** `nvim`, `zsh`, `git`. **Ignore** `ghostty`, `svim`, `aerospace` (and other
unused GUI/WM packages) unless asked — they are kept but not in use.

## Neovim (`nvim/.config/nvim/`)

The center of gravity. Architecture:

- **`init.lua`** runs first and declares every plugin via `vim.pack.add` (built-in manager,
  Neovim 0.12+; no bootstrap). Because plugins are present before any `plugin/` file runs,
  **all downstream `setup()` calls are eager** — there is no lazy-loading machinery to thread
  state through. Versions are pinned in `nvim-pack-lock.json` (commit it). Update with
  `:lua vim.pack.update()`.
- **`plugin/NN_*.lua`** load in numeric order: `10_options`, `11_keymaps`, `12_autocmds`,
  `20_plugins` (plugin `setup()`), `21_lsp`.
- **`lsp/<name>.lua`** are auto-discovered config files enabled by `vim.lsp.enable({...})` in
  `21_lsp.lua`. Language servers are installed via **Homebrew, listed in the `Brewfile`**
  (`texlab`, `lua-language-server`) — not by any in-editor installer. Completion capabilities
  are injected globally by blink.cmp, so server files need none.
- **`after/ftplugin/<ft>.lua`** hold filetype-local options/keymaps; **`snippets/<ft>.lua`** are
  LuaSnip snippets loaded lazily by filetype.

Plugin stack (deliberately small): **mini.nvim** for most editor features (files, pick, git,
statusline, tabline, ai/surround, icons, notify), **blink.cmp + LuaSnip** for completion and
snippets, **vimtex** for LaTeX. Completion keymaps are split on purpose: Tab / `<C-l>` / `<C-h>`
stay 100% LuaSnip (`preset = 'none'` in blink), blink owns `<C-n/p/y/e/space>`.

**LaTeX is the design target.** vimtex previews via **sioyek**; tex completion is intentionally
Overleaf-style (LSP + snippets only, no buffer-word menu noise — see the `per_filetype` comment
in `20_plugins.lua`); `after/ftplugin/tex.lua` swaps screen/text motions and adds vimtex insert-mode
math maps. When touching LaTeX behaviour, preserve the "only show a menu after `\`, `{`, etc."
intent.

## Colorscheme: terminal-anchored palette

`colors/edge-ansi.lua` is the single most cross-cutting design decision. **`termguicolors` is OFF
on purpose** (`plugin/10_options.lua`): all highlights use the terminal's 16 ANSI slots. The hex
values for those slots live in **`palette/edge-light.yaml`** (repo root, app-independent), which is
the single source of truth for color. Every consumer mirrors it: the ghostty theme
(`ghostty/.config/ghostty/themes/edge`), the iTerm profile (`iterm2/`), nvim's slot mapping, and the
zsh UIs. The **same ANSI palette is mirrored everywhere** — zsh-syntax-highlighting, fzf
(`FZF_DEFAULT_OPTS`), fzf-tab, and the pure prompt in `.zshrc` all map onto slots 0–15 so every UI
matches the editor. If you change a color, edit `palette/edge-light.yaml` first, then propagate the
slot meaning consistently across the terminal emulators, nvim, *and* zsh; do not introduce truecolor
hex into nvim highlights. Highlighting philosophy follows
tonsky.me/blog/syntax-highlighting (color only what carries meaning; comments yellow not grey;
punctuation greyed).

## zsh (`zsh/.config/zsh/`)

- XDG-first: history/caches redirected under `$XDG_CACHE_HOME`; `.zshenv` (in `$HOME`) sets the
  XDG vars and `ZDOTDIR`.
- **Plugins are cloned on demand, not vendored.** `zsh-add-plugin "owner/repo"` git-clones into
  `$ZDOTDIR/plugins/` on first run and sources it; `zsh-update-plugins` pulls them. The
  `plugins/` directory is gitignored — do not commit plugin sources.
- vi mode throughout, with cursor-shape switching and history-search rebinds.

## Roadmap (planned work)

Things the user intends to do eventually — not yet implemented:

1. Set up **fzf + fzf-lua** in nvim to replace `mini.pick` as the fuzzy finder.
2. Move the terminal to **ghostty** (currently kept but unused).
3. Set up **yabai** as a keyboard-driven window manager.
4. Properly configure **sioyek** (the main PDF reader, already wired as vimtex's previewer).
5. Set up **Claude integration inside nvim**.
6. Use a combination of **zoxide + fzf** for faster directory navigation in zsh.

## Conventions

- Sections within config files are wrapped in fold markers: `-- foo -->` … `-- <--`
  (`# foo -->` in zsh). Keep using them.
- Indentation is **hard tabs**, `shiftwidth=2` (`expandtab` is off).
- Disabled-but-kept config is left commented in place with a note on how to re-enable
  (see the bottom of `20_plugins.lua`); follow that pattern instead of deleting.
- There is no build/test/lint step — this is a configuration repo. "Running" a change means
  re-sourcing (`<Leader>Ls` / `<Leader>Lc` in nvim) or starting a fresh shell.
