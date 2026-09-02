# nvim

A **nixvim** flake that generates a plain, first-party Neovim config. Consumed as a home-manager
module (`homeModules.default`, wired by `dotfiles/home.nix` via `programs.nixvim.imports = [ ./nvim ]`)
and buildable standalone (`nix build .#`, `nix run .#`). No `vim.pack`, no in-editor plugin manager,
no `mason`. Plugin versions are pinned by `flake.lock` (update with `nix flake update`).

Architecture: **one root module per cross-cutting concern**. Each concern owns its plugins +
keymaps + autocmds + its slice of the colorscheme. `default.nix` is just the imports list.

## Merge mechanism (why a language module can touch everything)

nixvim merges option definitions across modules. So a single `lang/*` module can contribute at once
to: `lsp.servers.<name>` (attrset), `plugins.treesitter.grammarPackages` (list),
`plugins.luasnip.fromLua` (list), `plugins.mini.modules` (attrset), and `colors.extraLua` (lines).
mini.nvim is **one plugin split across concerns** (`editing/mini.nix`, `git/`, `ui/notifications/`).

## Colorscheme

`termguicolors` is **OFF** — every highlight uses the terminal's 16 ANSI slots (0–15). Slot → hex
comes from `~/home/themes/edge-vague.nix`, not from here. `core/highlights.lua` is the **prelude**
(palette locals, `hl`/`link` helpers, `Ui*` surface units, fundamental groups); each concern owns a
`highlights.lua` fragment wired with `colors.extraLua = builtins.readFile ./highlights.lua`.
`core/colorscheme.nix` splices prelude + all fragments into one `colors/ansi.lua` at build.

## Tree

```
flake.nix              standalone nixvim flake (nix build/run .#, checks.nvim)
flake.lock             plugin version pins
default.nix            imports list only
lz-n.nix               lazy-load placeholder — NOT imported anywhere

core/
  default.nix          leader (space), swapfile off, esc/macro/write/quit + <C-hjkl> window maps
  colorscheme.nix      declares the colors.extraLua option; colorscheme = "ansi"; splices colors/ansi.lua
  highlights.lua       colorscheme PRELUDE: ANSI palette locals, hl/link, Ui* units, editor/syntax/diff groups

editing/
  default.nix          editing opts (expandtab OFF, shiftwidth/tabstop 2, autoindent); o/O/K/u maps; yank highlight
  treesitter.nix       grammars; highlight.enable = false, indent.enable = true
  snippets.nix         LuaSnip engine (autosnippets, Tab cut-key) + <Tab>/<C-l>/<C-h> expand/jump maps
  mini.nix             mini.ai + mini.pairs + mini.surround
  blink.nix            EMPTY stub (blink.cmp not ported); imported but declares nothing
  fold.nix             foldcolumn 0 + fold fillchar + foldtext autocmd
  fold.lua             make_foldtext() (marker-fold text)
  highlights.lua       treesitter @capture highlight groups

ui/
  default.nix          UI opts (number/relativenumber, cursorline, scrolloff 20, cmdheight 0, termguicolors OFF,
                       statuscolumn), ui2 experimental enable
  devicons.nix         web-devicons (color_icons off, default glyph override)
  statuscolumn.lua     make_statuscolumn()
  statusline/
    default.nix        lualine, per-window (globalstatus OFF); maps sections to Stl* highlight groups
    highlights.lua     statusline groups
  notifications/
    default.nix        mini.notify (NE anchor, borderless) + :Notifications history command
    notify-defs.lua    _M.notify format definitions
    notify-wire.lua    vim.notify wiring
    highlights.lua     notify groups

find/
  default.nix          fzf-lua finder (custom borders/colors) + <leader>f{f,b,g,h,H,l,L} maps + vim.ui.select backend
  highlights.lua       FzfLua* groups

files/
  default.nix          oil float file explorer + <leader>e{f,d,n,z} explore maps (open dotfiles / nvim / zsh dirs)
  highlights.lua       Oil* groups

git/
  default.nix          mini.git + <leader>gc (commit) / <leader>ga (diff --cached) maps

lsp/
  default.nix          LSP keymaps (gd, gD, <leader>d diagnostic) + diagnostics only — SERVERS live in lang/
  highlights.lua       @lsp.* + Diagnostic* groups

lang/                  one module per language; each bundles LSP server + ftplugin opts + snippets + syntax
  default.nix          imports
  nix.nix              nixd (ships WITH nvim via extraPackages — self-contained); root markers flake.nix/.git
  lua.nix              lua_ls (on PATH) + lua ftplugin (nowrap, sidescrolloff)
  help.nix             help ftplugin: q closes, <cr> follows tag, <bs> pops
  zsh/                 zsh ftplugin + zshFunction highlight
  tex/                 vimtex (sioyek preview) + texlab (on PATH) + math imaps + after/syntax/tex.vim
                       + snippets/tex.lua + compile-notify; the LaTeX design target
  asy/                 asymptote ftplugin: makeprg + <leader>ll compile / <leader>lv view + compile-notify
```

## Notes

- **Language servers**: `nixd` ships with nvim (`extraPackages`). `lua_ls`/`texlab` are referenced by
  `cmd` and expected on PATH (Homebrew). Completion capabilities are injected by nixvim.
- **LaTeX is the design target**: vimtex previews via **sioyek**; keep the Overleaf-style intent
  (LSP + snippets, minimal menu noise).
- **Window nav** (`<C-hjkl>`) is overridden by `shell/tmux/nav.nix` when tmux is enabled, giving
  seamless nvim ↔ tmux pane movement.
- "Running" a change = rebuild (home-manager switch, or `nix build .#`). `nix flake check` evaluates
  the module and boots nvim headless. See `../CLAUDE.md` for the full design rationale.
