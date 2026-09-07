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
`plugins.luasnip.fromLua` (list), `plugins.mini.modules` (attrset), and `colors.groups` (attrset).
mini.nvim is **one plugin split across concerns** (`editing/mini.nix`, `git/`, `ui/notifications/`).

## Colorscheme

`termguicolors` is **OFF** — every highlight uses the terminal's 16 ANSI slots (0–15). Slot → hex
comes from `~/home/themes/edge-vague.nix`, not from here.

Highlights are **nix data**, not Lua. Each concern sets `colors.groups.<Group>` — a typed attrset
(integer `fg`/`bg` = ANSI slots, bool `bold`/`italic`/`underline`/`undercurl`/`strike`, or a `link`)
— merged across every module. `core/colorscheme.nix` is the machinery: it declares the
`colors.groups` option, renders the merged set into one `colors/ansi.lua` at build (`mkAnsi`, emitting
integer `ctermfg`/`ctermbg`), and exposes the group-building helpers as the `hl` arg
(`hl.clear`/`hl.linkTo`/`hl.withFg` — assign one spec to a list of names). `core/palette.nix` holds
the slot table + semantic roles (`accent`, `selection`), injected as the `palette` arg.

Groups live in a `highlights.nix` per concern (`colors.groups = { … }`, wired via `imports`): core's
`Ui*` units + fundamental groups in `core/highlights.nix`, treesitter in `editing/`, `@lsp.*` +
diagnostics in `lsp/`, and so on. Links resolve by name at runtime, so contribution order is
irrelevant. Prefer `link` to a `Ui*` unit or a fundamental group over literal slots.

The 16 ANSI slots are shared across the whole environment: nvim (`core/palette.nix`),
zsh-syntax-highlighting (`shell/zsh/syntax.nix`), fzf (`shell/fzf.nix`), fzf-tab, bat
(`shell/bat/ansi16.tmTheme`), and the pure prompt all hardcode slots 0–15 and inherit hex
transitively from the running terminal. Only GUIs that need hex read the `theme` arg directly:
ghostty (`ghostty/default.nix`, via `programs.ghostty.themes`), plus jankyborders and sioyek in
`~/home`. Change a color in `themes/edge-vague.nix` and the slot consumers follow automatically.
Highlighting philosophy follows tonsky.me/blog/syntax-highlighting: color only what carries meaning
(comments yellow not grey, punctuation greyed).

## Tree

```
flake.nix              standalone nixvim flake (nix build/run .#, checks.nvim)
flake.lock             plugin version pins
default.nix            imports list only
lz-n.nix               lazy-load placeholder — NOT imported anywhere

core/
  default.nix          leader (space), swapfile off, esc/macro/write/quit + <C-hjkl> window maps
  palette.nix          ANSI slot table + semantic roles, injected as the `palette` arg
  colorscheme.nix      colors.groups option + mkAnsi renderer + hl helpers (via _module.args.hl); colorscheme = "ansi"
  highlights.nix       Ui* surface units + fundamental editor/syntax/diff groups

editing/
  default.nix          editing opts (expandtab OFF, shiftwidth/tabstop 2, autoindent); o/O/K/u maps; yank highlight
  treesitter.nix       grammars; highlight.enable = false, indent.enable = true
  mini.nix             mini.ai + mini.pairs + mini.surround
  fold.nix             foldcolumn 0 + fold fillchar + foldtext autocmd
  fold.lua             make_foldtext() (marker-fold text)
  highlights.nix       treesitter @capture highlight groups

completion/
  default.nix          imports (blink + snippets)
  blink.nix            blink.cmp menu (luasnip preset); auto_show gated on <=5 items + hide-on-grow hook; <C-x/j/k/y/e> keys
  snippets.nix         LuaSnip engine (autosnippets, Tab cut-key) + <Tab>/<S-Tab> expand-or-jump maps

ui/
  default.nix          UI opts (number/relativenumber, cursorline, scrolloff 20, cmdheight 0, termguicolors OFF,
                       statuscolumn), ui2 experimental enable
  devicons.nix         web-devicons (color_icons off, default glyph override)
  statuscolumn.lua     make_statuscolumn()
  statusline/
    default.nix        lualine, per-window (globalstatus OFF); maps sections to Stl* highlight groups
    highlights.nix     statusline (Stl*) groups
  notifications/
    default.nix        mini.notify (NE anchor, borderless) + :Notifications history command
    notify-defs.lua    _M.notify format definitions
    notify-wire.lua    vim.notify wiring
    highlights.nix     notify (Ntf*) groups

find/
  default.nix          fzf-lua finder (custom borders/colors) + <leader>f{f,b,g,h,H,l,L} maps + vim.ui.select backend
  highlights.nix       FzfLua* groups

files/
  default.nix          oil float file explorer + <leader>e{f,d,n,z} explore maps (open dotfiles / nvim / zsh dirs)
  highlights.nix       Oil* groups

git/
  default.nix          mini.git + <leader>gc (commit) / <leader>ga (diff --cached) maps

lsp/
  default.nix          LSP keymaps (gd, gD, <leader>d diagnostic) + diagnostics only — SERVERS live in lang/
  highlights.nix       @lsp.* + Diagnostic* + Lsp* groups

lang/                  one module per language; each bundles LSP server + ftplugin opts + snippets + syntax
  default.nix          imports
  nix.nix              nixd (ships WITH nvim via extraPackages — self-contained); root markers flake.nix/.git
  lua.nix              lua_ls (on PATH) + lua ftplugin (nowrap, sidescrolloff)
  help.nix             help ftplugin: q closes, <cr> follows tag, <bs> pops
  zsh/                 zsh ftplugin + zshFunction highlight (highlights.nix)
  tex/                 vimtex (sioyek preview, syntax_enabled=0, fold_enabled=0) + texlab (on PATH) +
                       treesitter latex highlighting + detection: setup.lua overrides
                       vimtex#syntax#in_mathzone with a treesitter check (feeds imaps), i$/a$ via
                       mini.ai treesitter textobject, indentexpr guard leaves verbatim/minted/listing
                       bodies alone (latex has no indents.scm); treesitter folding via query.set of
                       folds.scm (#trim-blank! drops open-ended sections' trailing blanks, #prelude!
                       folds the preamble); injections highlight code blocks;
                       after/queries/latex/highlights.scm (#first-char! + #in-math?) with its tex
                       capture groups in highlights/highlights.nix + math imaps +
                       snippets/tex.lua + compile-notify; the design target
  asy/                 asymptote ftplugin: makeprg + <leader>ll compile / <leader>lv view + compile-notify
```

## Notes

- **Language servers**: `nixd` ships with nvim (`extraPackages`). `lua_ls`/`texlab` are referenced by
  `cmd` and expected on PATH (Homebrew). Completion capabilities are injected by nixvim.
- **LaTeX is the design target**: vimtex previews via **sioyek**; keep the Overleaf-style intent
  (LSP + snippets, minimal menu noise).
- **Completion**: blink shows the menu; it auto-opens only when the list is short (`auto_show`
  requires `#items <= 5`, source-agnostic), so a narrowed set pops while broad lists (tex `\`) stay
  closed. `auto_show` gates only the *initial* open, so an `extraConfigLuaPost` hook re-runs the gate
  on every async list update and hides the menu when it grows past the threshold (reusing
  `menu.auto_show.enabled`, which `<C-x>` force-show sets to always-true, so a forced menu is never
  auto-closed). Sources are blink defaults: buffer stays an LSP/path fallback (runs only when they
  return nothing), so completion is LSP-first with buffer as backup. `<C-x>` forces the menu open,
  `<C-j>`/`<C-k>` select, `<C-y>` accept, `<C-e>` cancel. Snippets are LuaSnip's, driven by `<Tab>`
  (expand-or-jump-forward, else a literal Tab) / `<S-Tab>` (jump back) — decoupled from the menu.
- **Window nav** (`<C-hjkl>`) is overridden by `shell/tmux/nav.nix` when tmux is enabled, giving
  seamless nvim ↔ tmux pane movement.
- "Running" a change = rebuild (home-manager switch, or `nix build .#`). `nix flake check` evaluates
  the module and boots nvim headless. See `../CLAUDE.md` for the full design rationale.
