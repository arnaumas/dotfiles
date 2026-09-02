# ghostty

`programs.ghostty` module. The one **GUI terminal that takes hex** directly: it reads the `theme`
arg and builds its light/dark palettes inline, so no separate theme file exists.

## Tree

```
default.nix   programs.ghostty: font (Geist Mono, no ligatures, thickened), cursor bar,
              quick-terminal (center, 30%), macOS titlebar hidden, window padding;
              theme = "light:light,dark:dark" with both themes built from the `theme` arg via mkPalette
```

## Notes

- `mkPalette` maps `theme.{black,red,…,greyBg}` onto ghostty palette slots `0..15`; foreground/
  background/selection come from the `uiFg`/`termBg`/`uiBg` roles. Source of truth for those hex
  values: `~/home/themes/edge-vague.nix`.
- `package = null`: ghostty itself is installed out-of-band (Homebrew cask); this module only writes
  its config.
- Migration to **kitty** is planned (see `../ROADMAP.md` Phase 4); ghostty stays until parity.
