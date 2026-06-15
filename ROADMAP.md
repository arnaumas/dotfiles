# ROADMAP

Planned changes pulled from analyzing [`benbrastmckie/nvim`](https://github.com/benbrastmckie/nvim)
(a maximalist LaTeX config — 57 plugins, lazy.nvim, mason, telescope, large AI module)
against this deliberately **minimal** setup. Most of that config's architecture is the
opposite of the bias kept here (vim.pack, mini.nvim, Homebrew LSPs, ANSI-anchored
colorscheme). Only the items below are worth pulling; each is config-only except the
completion-engine migration.

**Scope decided:** all four dependency-free pulls (vimtex polish, built-in spell,
mini.clue, templates + env-surround), plus cmp-vimtex via a **blink.cmp → nvim-cmp**
migration.

> Tradeoff to remember: the engine migration is the one piece that *adds* dependencies
> — nvim-cmp needs ~5 companion source plugins where blink.cmp is a single plugin — so
> it runs against the minimal-deps bias. It is in scope because it was explicitly
> chosen; the design preserves the current UX and leaves the rest of the stack untouched.

---

## 1 — Completion engine migration: blink.cmp → nvim-cmp + cmp-vimtex

Preserve current behavior exactly: LuaSnip keeps Tab / `<C-l>` / `<C-h>` (independent
LuaSnip maps in `plugin/11_keymaps.lua`, unaffected by the engine); the menu is driven
by `<C-n/p/y/e>` + `<C-space>`; tex stays Overleaf-style (menu only after `\`, `{`, …).

**1a. `nvim/.config/nvim/init.lua`** — swap the plugin set:
- Remove `saghen/blink.cmp` (and its v1/v2 comment).
- Add (keep `LuaSnip`): `hrsh7th/nvim-cmp`, `hrsh7th/cmp-nvim-lsp`,
  `hrsh7th/cmp-buffer`, `hrsh7th/cmp-path`, `saadparwaiz1/cmp_luasnip`,
  `micangl/cmp-vimtex`.
- After editing, run `:lua vim.pack.update()` and commit `nvim-pack-lock.json`.

**1b. `nvim/.config/nvim/plugin/20_plugins.lua`** — replace the `blink.cmp` block with
`cmp.setup`:
- `snippet.expand` → `luasnip.lsp_expand`.
- Mapping (mirror today's keys): `<C-space>` = `cmp.mapping.complete()`,
  `<C-n>` = `select_next_item`, `<C-p>` = `select_prev_item`, `<C-y>` = `confirm`,
  `<C-e>` = `abort`. Do **not** map Tab/`<C-l>`/`<C-h>` (left to LuaSnip).
  `<C-k>` = `vim.lsp.buf.signature_help` (built-in; replaces blink's signature popup).
- Default sources: `nvim_lsp`, `luasnip`, `buffer` (`keyword_length = 5`), `path`.
  Port the "no buffer source inside comments/strings" treesitter gate from the current
  blink config via the buffer source's `entry_filter`/`enabled`.
- `cmp.setup.filetype('tex', { sources = { {name='nvim_lsp'}, {name='vimtex'},
  {name='luasnip'} } })` — texlab + cmp-vimtex (citations/refs) + snippets, **no buffer**
  → preserves Overleaf-style. Configure `cmp_vimtex` (bibtex_parser on; info in menu).
- Update the fold-marker comments to describe nvim-cmp.

**1c. `nvim/.config/nvim/plugin/21_lsp.lua`** — blink injected capabilities globally;
replace with cmp-nvim-lsp. Keep `lsp/*.lua` clean by setting once on the wildcard:
`vim.lsp.config('*', { capabilities = require('cmp_nvim_lsp').default_capabilities() })`.

**1d. `nvim/.config/nvim/after/ftplugin/tex.lua`** — set
`vim.bo.omnifunc = 'vimtex#complete#omnifunc'` (cmp-vimtex relies on it).

**1e. `CLAUDE.md`** — update the plugin-stack paragraph, the completion-keymap note, and
the "capabilities injected by blink.cmp" line in the Neovim section to reflect nvim-cmp.

---

## 2 — Vimtex polish (pure config, zero deps)

Add to the vimtex block in `plugin/20_plugins.lua`:
- `vim.g.vimtex_compiler_latexmk = { build_dir='build', out_dir='build', aux_dir='build',
  options={'-interaction=nonstopmode','-file-line-error','-synctex=1'} }` — keeps
  `.aux/.log/...` out of the source tree.
- `vim.g.vimtex_quickfix_ignore_filters = { 'Underfull','Overfull','specifier changed to',
  'Token not allowed in a PDF string','Package hyperref Warning' }` and matching
  `vim.g.vimtex_log_ignore` — silences usual warning noise (complements the existing
  `vimtex_quickfix_open_on_warning = 0`).

## 3 — Built-in spell + personal dictionary (built-in, zero deps)

The colorscheme already defines the `SpellBad/SpellCap/...` undercurl highlights
(`colors/light.lua`) — currently unused.
- Enable per-filetype (not global) in `after/ftplugin/tex.lua`:
  `vim.opt_local.spell = true`, `vim.opt_local.spelllang = 'en_us'`. (Same for markdown
  if/when wanted.)
- Add `nvim/.config/nvim/spell/en.utf-8.add` (new, committed) so `zg`-added words travel
  with the dotfiles. Point `spellfile` at it.

## 4 — mini.clue leader-key discovery (in mini.nvim, zero new deps)

mini.clue is the minimal which-key equivalent already shipped in mini.nvim. The leader
maps in `plugin/11_keymaps.lua` already carry `desc=` labels, so setup is small. Add
`require('mini.clue').setup(...)` in `plugin/20_plugins.lua` with triggers for
`<Leader>` (n/x), registers, marks, and window (`<C-w>`) commands, plus the gen_clues
presets.

## 5 — Templates + environment surround (built-in / mini, zero new deps)

- **Templates:** add `nvim/.config/nvim/templates/` with a couple of `.tex` skeletons
  (e.g. `article.tex`) and a few buffer-local `<leader>T*` maps in
  `after/ftplugin/tex.lua` that `:read` them (pure built-in).
- **Env surround:** mini.surround (already used) supports custom surroundings. Add a
  buffer-local `vim.b.minisurround_config` in the tex ftplugin with an `e` surrounding
  that prompts for an environment name and wraps the selection in
  `\begin{env} … \end{env}`. (vimtex already covers *editing* envs via `cse/dse/tse`;
  this adds quick *wrapping*.)

---

## Explicitly NOT pulled (anti-aligned)

lazy.nvim, mason, telescope (heavier than mini.pick — and the fzf-lua roadmap goal is
leaner still), lualine/bufferline/neo-tree/snacks (covered by mini), nvim-surround
(mini.surround stays), the AI stack (avante/mcphub/opencode/lectic — the only aligned AI
takeaway is the thin terminal-based `claude-code.nvim`), gruvbox + termguicolors,
notifications/session/jupyter/himalaya/typst/lean.

---

## Verification

- `:lua vim.pack.update()` succeeds; `:checkhealth vimtex`; open a `.tex`.
- Completion: `\cite{` and `\ref{` → menu from project `.bib`/labels (cmp-vimtex); plain
  prose words pop **no** menu (Overleaf-style preserved); Tab/`<C-l>`/`<C-h>` still jump
  LuaSnip; `<C-n/p/y/e>` drive the menu; `<C-k>` shows signature.
- In lua/python buffers: `nvim_lsp` + `buffer` (≥5 chars, not in comments) + `path`; no
  menu noise inside comments/strings.
- Compile (`<leader>ll` / `:VimtexCompile`): artifacts land in `build/`; `:VimtexView`
  opens sioyek at the right page (SyncTeX forward + inverse). Quickfix no longer fills
  with Overfull/Underfull.
- Spell: misspell in `.tex` → undercurl; `zg` writes to `spell/en.utf-8.add`.
- mini.clue: press `<Leader>` and pause → labeled hint window appears.
- Templates: `<leader>T…` reads a skeleton; visual-select + env-surround wraps in an
  environment via the prompt.
