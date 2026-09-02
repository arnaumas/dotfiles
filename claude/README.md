# claude

Claude Code configuration, dropped into `~/.config/claude/` via `xdg.configFile`.
(`CLAUDE_CONFIG_DIR` is pointed here by `shell/core.nix`.)

## Tree

```
default.nix            xdg.configFile for each item below
CLAUDE.md              global personal instructions for Claude Code across all projects
settings.json          Claude Code settings (incl. statusline command wiring)
statusline-command.sh  script that renders the Claude Code status line
skills/
  handoff/SKILL.md     "handoff" skill — capture session progress to resume later
  pickup/SKILL.md      "pickup" skill — reconstruct context from a handoff document
```

## Notes

- These are verbatim source files; edit them here, not in `~/.config/claude` (that path is a nix
  symlink and is overwritten on switch).
