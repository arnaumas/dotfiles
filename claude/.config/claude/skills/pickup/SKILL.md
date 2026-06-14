---
name: pickup
description: Reconstruct context from a session handoff document to resume work efficiently. Use when the user runs /pickup, says "pick up where I left off", "continue from last session", "load context", or "resume work" — with optional time references like "from yesterday", "from monday", or a specific timestamp. Restores project state, in-progress work, and key decisions while minimizing token consumption.
---

# Session Pickup

Companion to handoff. Reads a handoff checkpoint and reconstructs working context silently — no narration, no progress updates, no confirmation messages unless something is wrong.

## Locate the Handoff

Files in `.claude/checkpoints/` are named `yyyy-mm-ddTHH:mm.md`. List them with:

```bash
ls -1 .claude/checkpoints/ | sort
```

Then select based on user input:

| Input | Selection |
|---|---|
| No time given, or "latest" / "last session" | Most recent file |
| "yesterday" | Most recent file with yesterday's date |
| A weekday name ("monday") | Most recent file on that weekday |
| "last week" | Most recent file from the previous calendar week |
| A timestamp or partial date ("14:30", "june 10") | Closest match |

If no match found, list available checkpoints and ask the user to pick one.

## Reconstruct Context

Read the handoff file. Load additional context in priority order:

**Always load:**
- Status (branch, test state, uncommitted changes)
- What's In Progress + any `file:line` references
- Gotchas for Next Session

**Load unless large:**
- Key Decisions Made
- Learnings Captured

**Load only if directly relevant to In Progress work:**
- Specific file regions mentioned (`file.ts:42` → read ±20 lines, not the whole file)
- What's Done / What's Pending (only if In Progress references them)

Use `sed -n 'START,ENDp' file` to read line ranges. Do not load entire files.

## Verify State

```bash
git branch --show-current
git status --short
git log --oneline -3
```

If branch or state doesn't match the handoff, flag the discrepancy before proceeding.

## Output

One brief summary only — no step-by-step narration:

```
Resumed from [date]. Branch: [branch]. [1 sentence on what's in progress].
Next: [Resume Command from handoff]
```

Then stop. Wait for the user to direct next action.

## Guardrails

- Do not echo back the handoff file contents
- Do not ask clarifying questions unless state is ambiguous or mismatched
- Do not load files speculatively — only what In Progress explicitly references
- If handoff is incomplete or stale, say so once and ask how to proceed
