# ROADMAP

The nvim config is now the **nixvim flake** under `nvim/` (standalone
`makeNixvimWithModule`, installed via `nix profile`). The traditional
`nvim/.config/nvim/` tree is retired. Layout: `core/`, `plugins/`, `filetypes/`,
`colors/`, each a directory of `.nix` modules imported by `nvim/default.nix`.

Two tracks below:
- **Structural** (1–4): refactor → lazy-load → completion → home-manager. Do in order;
  each leans on the previous.
- **Feature backlog** (5–8): carried over from the `benbrastmckie/nvim` analysis,
  re-scoped from the deleted `.config` files to the nix modules. Independent of the
  structural track; pull whenever.

---

## Structural track

### 1 — Modular refactor: kill the `__raw` Lua smell

Prereq for clean lazyLoad specs (they live in the same per-plugin files). See memory
`nixvim-port-raw-lua-smell`.

- Replace long embedded Lua heredocs (`__raw = ''…''`) with **typed nixvim options**
  wherever the option exists, so config is declarative Nix, not spliced strings.
- Known offenders: `plugins/lualine.nix` (the `fmt` closure + the 5 icon `\u{…}` strings),
  `plugins/snippets/default.nix` (the three `action.__raw` jump functions),
  `plugins/mini/notify-wire.lua` glue, any remaining `extraConfigLua` blobs.
- `__raw` is Lua **code**: a string value needs inner quotes (`icon.__raw = ''""''`).
  Nix has no `\u` escape — use `''…''` + inner Lua quotes, or a literal glyph.
- Keep `.lua`/`.vim` sidecar files (`core/fold.lua`, `vimtex/tex.vim`, snippets) as files;
  the target is inline `__raw`, not legitimately-separate scripts.

### 2 — Lazy loading via lz-n

`plugins/lz-n.nix` is scaffolded but a placeholder. Config is all-eager today (mirrors the
old `vim.pack` model).

- Enable lz-n as the loader (`plugins.lz-n.enable = true`), then attach per-plugin
  `lazyLoad` specs in each plugin module.
- Highest-value defers: **vimtex** (`ft = "tex"`), **fzf-lua** (cmd + the finder keymaps),
  the **completion engine** (`event = "InsertEnter"`), **oil** (cmd/keys).
- Leave eager what must run at startup: colorscheme, options, statusline, mini core.
- Verify startup with `nvim --startuptime`; watch for ftplugin/autocmd ordering regressions
  a deferred plugin can introduce.

### 3 — Completion engine: blink.cmp → nvim-cmp + cmp-vimtex

Adds deps (nvim-cmp needs ~5 companion source plugins vs blink's single plugin) — against
the minimal bias, but chosen for `cmp-vimtex` (citation/ref completion from the project
`.bib`). **Preserve current UX exactly**: LuaSnip keeps Tab / `<C-l>` / `<C-h>` (its maps
live in `plugins/snippets/default.nix`, engine-independent); the menu is `<C-n/p/y/e>` +
`<C-space>`; tex stays Overleaf-style (menu only after `\`, `{`, …).

- **`plugins/blink.nix`** → replace with an nvim-cmp module set: `plugins.cmp` (nvim-cmp)
  plus source plugins `cmp-nvim-lsp`, `cmp-buffer`, `cmp-path`, `cmp_luasnip`. `cmp-vimtex`
  has no dedicated nixvim module — add via `extraPlugins` (pkg or flake input) and wire its
  source manually.
- **Mappings** in `plugins.cmp.settings`: `<C-space>`=`complete`, `<C-n>`=`select_next_item`,
  `<C-p>`=`select_prev_item`, `<C-y>`=`confirm`, `<C-e>`=`abort`. Do **not** map
  Tab/`<C-l>`/`<C-h>`. `<C-k>`=`vim.lsp.buf.signature_help` (replaces blink's signature popup).
- **Sources** default: `nvim_lsp`, `luasnip`, `buffer` (`keyword_length = 5`), `path`. Port
  the current "no buffer source in comments/strings" treesitter gate.
- **tex filetype** (`plugins.cmp.settings.filetype` or `cmp.setup.filetype`): `nvim_lsp` +
  `vimtex` + `luasnip`, **no buffer** → keeps Overleaf-style. Configure `cmp_vimtex`
  (bibtex parser on; info in menu).
- **Capabilities**: blink injects LSP capabilities globally today. Replace in `plugins/lsp.nix`
  with cmp-nvim-lsp on the wildcard: `vim.lsp.config('*', { capabilities =
  require('cmp_nvim_lsp').default_capabilities() })`.
- **`filetypes/tex.nix`**: set `vim.bo.omnifunc = 'vimtex#complete#omnifunc'` (cmp-vimtex
  relies on it).
- Update `CLAUDE.md`'s plugin-stack + completion-keymap notes (they still say blink.cmp).

### 4 — home-manager

The structural capstone. `flake.nix` already documents it (the comment above the
`makeNixvimWithModule` block).

- Drop the standalone `makeNixvimWithModule` output; add a home-manager module with
  `programs.nixvim = { enable = true; imports = [ ./. ]; }` — the whole `nvim/` module tree
  moves over unchanged.
- Switch install from `nix profile add` to `home-manager switch`; `nvim` then comes from the
  HM-managed profile.
- Longer horizon: fold the other stow packages (**zsh, git, tmux**) into the same HM config
  and retire stow entirely. Big enough to be its own roadmap when reached.

---

## Feature backlog (re-scoped to nix modules)

### 5 — Vimtex polish (pure config, zero deps)

In `plugins/vimtex/default.nix`, via `plugins.vimtex.settings` (g: vars):
- `compiler_latexmk = { build_dir = "build"; out_dir = "build"; aux_dir = "build";
  options = [ "-interaction=nonstopmode" "-file-line-error" "-synctex=1" ]; }` — keeps
  `.aux/.log/…` out of the source tree.
- `quickfix_ignore_filters` (Underfull/Overfull/"specifier changed to"/"Token not allowed in
  a PDF string"/"Package hyperref Warning") + matching `log_ignore` — silences warning noise
  (complements the existing `quickfix_open_on_warning = 0`).

### 6 — Built-in spell + personal dictionary (built-in, zero deps)

`colors/hl_groups.lua` already defines the `SpellBad/SpellCap/…` undercurl groups (unused).
- Enable per-filetype in `filetypes/tex.nix` (localOpts, not global): `spell = true`,
  `spelllang = "en_us"`. (markdown too if/when wanted.)
- Ship `spell/en.utf-8.add` via `extraFiles` (or a files.<path> entry) so `zg`-added words
  travel with the config; point `spellfile` at it.

### 7 — mini.clue leader-key discovery (in mini.nvim, zero new deps)

Minimal which-key equivalent, already in mini.nvim. Leader maps already carry `desc=`.
- Enable the `clue` module in `plugins/mini/default.nix` with triggers for `<Leader>` (n/x),
  registers, marks, and window (`<C-w>`) commands, plus the gen_clues presets.

### 8 — Templates + environment surround (built-in / mini, zero new deps)

In `filetypes/tex.nix`:
- **Templates:** ship `templates/*.tex` skeletons via `extraFiles`; buffer-local `<leader>T*`
  maps that `:read` them.
- **Env surround:** mini.surround (already used) custom surroundings — a buffer-local
  `vim.b.minisurround_config` with an `e` surrounding that prompts for an environment name and
  wraps the selection in `\begin{env} … \end{env}`. (vimtex covers *editing* envs via
  `cse/dse/tse`; this adds quick *wrapping*.)

---

## Explicitly NOT pulled (anti-aligned, kept out on purpose)

lazy.nvim (lz-n instead), mason (Homebrew LSPs), telescope (fzf-lua), lualine already the one
concession, bufferline/neo-tree/snacks (mini), nvim-surround (mini.surround), the AI stack
(avante/mcphub/opencode/lectic — only aligned takeaway is a thin terminal `claude-code.nvim`,
see CLAUDE.md roadmap item 4), gruvbox + termguicolors, notifications/session/jupyter/
himalaya/typst/lean.

---

## Verification

- **Build**: `nix flake check` green; `nix run ~/dotfiles/nvim` launches; after committing,
  `nix profile upgrade nvim`.
- **Refactor (1)**: no behavior change; `rg '__raw' nvim/` shrinks to only genuine code
  closures; flake check still green (it boots nvim, catches E-level Lua).
- **Lazy (2)**: `nvim --startuptime` improves; deferred plugins still load on their trigger
  (open `.tex` → vimtex; `<leader>` finder → fzf-lua).
- **Completion (3)**: `\cite{`/`\ref{` → menu from project `.bib`/labels (cmp-vimtex); prose
  words pop **no** menu; Tab/`<C-l>`/`<C-h>` still jump LuaSnip; `<C-n/p/y/e>` drive the menu;
  `<C-k>` shows signature. lua/python: `nvim_lsp`+`buffer`(≥5, not in comments)+`path`.
- **home-manager (4)**: `home-manager switch` succeeds; `nvim` resolves to the HM profile.
- **Vimtex/spell/clue/templates (5–8)**: artifacts in `build/`; misspell → undercurl and `zg`
  writes to `spell/en.utf-8.add`; `<Leader>` pause → clue window; `<leader>T…` reads a skeleton
  and env-surround wraps a selection.
