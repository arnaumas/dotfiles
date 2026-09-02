# pi

The **pi coding agent** (pi.dev), a first-party nixpkgs package, plus its ANSI theme.

## Tree

```
default.nix   home.packages += pi-coding-agent; drops edge.json into ~/.pi/agent/themes/ via home.file
edge.json     16-slot ANSI "edge" theme (maps pi UI roles onto ANSI slots, matching the editor)
```

## How pi consumes the theme

- pi scans `~/.pi/agent/themes/*.json` (also `.pi/themes/` project-local). `home.file` symlinks
  `edge.json` there, so pi discovers it. Themes hot-reload.
- The `"name"` field (`edge`) is the selector: run `/theme edge` once. That persists to
  `~/.pi/agent/settings.json` (alongside `defaultProvider`/`defaultModel`), like `/model` does.
- **Auth** lives separately in `~/.pi/agent/auth.json`. Neither settings.json nor auth.json is
  managed by nix, so runtime `/login` and `/model` are not clobbered.

## Notes

- BYOK: provider + model are set interactively (`/login`, `/model`).
- Planned (see `../ROADMAP.md` Phase 4): local runtime via bare llama.cpp + MLX, DeepSeek remote.
