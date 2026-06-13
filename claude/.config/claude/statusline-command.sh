#!/bin/sh
# Claude Code status line command
# Reads JSON from stdin and prints a compact status line.

input=$(cat)

cwd=$(echo "$input" | jq -r '.cwd')
model=$(echo "$input" | jq -r '.model.display_name')
effort=$(echo "$input" | jq -r '.effort.level // empty')
used_tok=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_tok=$(echo "$input" | jq -r '.context_window.context_window_size // empty')
rl_5h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rl_wk=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

# Shorten $HOME to ~
home="$HOME"
short_cwd="${cwd/#$home/~}"

# ANSI colors (anchored to the terminal's 16-slot palette)
blue=$(printf '\033[34m')
reset=$(printf '\033[0m')

# Humanize a token count: 8500 -> 8.5k, 200000 -> 200k, 1000000 -> 1M
fmt_tok() {
	awk -v n="$1" 'BEGIN{
		if (n>=1000000) { v=n/1000000; s="M" } else { v=n/1000; s="k" }
		if (v==int(v)) printf "%d%s", v, s; else printf "%.1f%s", v, s
	}'
}

# Build status parts
# cwd (always shown, blue)
parts="${blue}${short_cwd}${reset}"

# model
parts="$parts  $model"

# effort level (when present)
if [ -n "$effort" ]; then
	parts="$parts [$effort]"
fi

# context usage as current/total tokens (only after first API call)
if [ -n "$used_tok" ] && [ -n "$total_tok" ]; then
	parts="$parts  ctx:$(fmt_tok "$used_tok")/$(fmt_tok "$total_tok")"
fi

# rate limits (Pro/Max only, after first API response)
if [ -n "$rl_5h" ]; then
	pct=$(echo "$rl_5h" | awk '{printf "%d", $1 + 0.5}')
	parts="$parts  5h:${pct}%"
fi
if [ -n "$rl_wk" ]; then
	pct=$(echo "$rl_wk" | awk '{printf "%d", $1 + 0.5}')
	parts="$parts  wk:${pct}%"
fi

printf '%s\n' "$parts"
