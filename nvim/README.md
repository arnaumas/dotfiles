# nixvim config

Neovim generated from Nix. Faithful port of `nvim/.config/nvim/`, one module per
plugin. Global config and ftplugins are typed Nix; only irreducible Lua/Vim
(snippets, tex syntax, the colorscheme, vimtex imaps, FoldText) stays as raw text.

## Layout

```
flake.nix                       standalone entry (the ONLY step-specific wiring)
nvim/
  modules/
    default.nix                 imports core + plugins + colorscheme
    core/
      options.nix               opts + globals (from 10_options.lua)
      keymaps.nix               global maps (from 11_keymaps.lua)
      autocmds.nix              yank highlight, cursor restore (12_autocmds.lua)
      filetypes.nix             typed `files` ftplugins: lua/zsh/help + tex motions
    plugins/
      mini.nix                  ai/surround/files/git/icons/notify + explore/git maps
      fzf-lua.nix               fuzzy finder + [f] maps
      lualine.nix               statusline/tabline (options typed, sections __raw)
      luasnip.nix               loader + settings + snippet-jump maps
      vimtex.nix                g:vimtex_* settings + tex imaps (files) + syntax
      lsp.nix                   native lsp module (texlab, lua_ls) + LspAttach maps
      blink.nix / lz-n.nix      NOT imported (deferred; see files)
    colorscheme.nix             colorscheme "ansi" + extraFiles colors/ansi.lua
  # raw runtime files (no typed equivalent):
  colors/ansi.lua               referenced by colorscheme.nix
  after/syntax/tex.vim          referenced by vimtex.nix
  snippets/tex.lua              loaded by luasnip.nix (fromLua)
```

Note: `after/ftplugin/*.lua` were copied earlier and are now **orphaned** (the
ftplugins are typed `files` entries). Delete them.

## Typed `files` vs raw

ftplugins use nixvim's **`files.<path>`** (typed: same options as the main config,
generated to a real ftplugin file). The tex ftplugin is a single generated
`after/ftplugin/tex.lua` contributed to by two modules that merge:
- `core/filetypes.nix` -> the motions (typed `opts` + `keymaps`)
- `plugins/vimtex.nix` -> the imaps (`extraConfigLua`, irreducible vimscript)

Raw text remains only where there is no schema: `snippets/tex.lua`,
`after/syntax/tex.vim`, `colors/ansi.lua`, lualine `sections` (`__raw`), the
vimtex imaps and `FoldText` (`extraConfigLua` inside their `files` entries).

## Not ported

- **blink.cmp** — deferred by request. No completion engine active until added.
- **lz.n** lazy loading — separate future layer (current config is all-eager).
- ansi.lua **per-plugin highlight split** + `Match` search-role group — next layer.

## Run

```
nix run .#default
```
`nix flake check` evaluates without launching.

## VERIFY on first build (unbuilt)

1. **`files` ftplugin semantics** — do `opts` emit `vim.opt` (global, matches the
   original) or `vim.opt_local` (buffer-local, arguably better)? And confirm
   `keymaps` respect `options.buffer = true` for filetype scoping.
2. **`lsp` native module shape** — is it `lsp.servers.<name>.config` with
   `cmd`/`filetypes`/`root_markers`? Fallback: verbatim `lsp/*.lua` + `vim.lsp.enable`.
3. **`require('vim._core.ui2')`** — experimental internal; pcall-guarded.
4. **`plugins.luasnip.fromLua`** — option name + nix-path `paths`.
5. **`plugins.fzf-lua`** — `register_ui_select` via extraConfigLua.
6. **`plugins.mini`** — `mockDevIcons`, `__raw` fns, `vim.notify` wiring.
7. **`plugins.lualine.settings`** — component nesting + `__raw` sections.
8. **`colorscheme = "ansi"`** loads after extraFiles ansi.lua is on rtp.
9. **`plugins.vimtex.settings`** keys map to `g:vimtex_*`.

## Migration path

Everything under `nvim/modules/` is portable across all three; only the top changes.

1. **standalone (now):** `flake.nix` `makeNixvimWithModule`.
2. **home-manager:** drop `packages`; add `programs.nixvim = { enable = true; imports = [ ./nvim/modules ]; };`.
3. **nix-darwin:** compose home-manager as a module.
```
