#!/usr/bin/env sh
# skhd runs bindings under launchd PATH (no /opt/homebrew/bin), same as yabai signals.
export PATH="/opt/homebrew/bin:$PATH"
# toggle focus between the floating and the tiled windows of the current space.
# directional focus only walks the bsp tree, so a floating window is otherwise
# unreachable from the keyboard, and there is no way back out of one either.

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/yabai"
mkdir -p "$CACHE"

windows=$(yabai -m query --windows --space)
cur=$(printf '%s' "$windows" | jq -r '.[] | select(."has-focus") | .id')
[ -z "$cur" ] && exit 0

# key off is-floating, not layer: `--toggle float` (hyper - f) leaves the window
# on layer normal, only yabairc's auto-float signal promotes one to layer above.
# so the two sets differ, and keying on the layer would miss hand-floated windows.
from=$(printf '%s' "$windows" | jq -r --argjson c "$cur" '.[] | select(.id == $c) | ."is-floating"')
[ "$from" = "true" ] && to=false || to=true

# is-visible drops parked scratchpads: they stay on the space with a stale frame
targets=$(printf '%s' "$windows" | jq -r --argjson t "$to" \
	'.[] | select(."is-floating" == $t and ."is-visible" and (."is-minimized" | not)) | .id')
[ -z "$targets" ] && exit 0

# remember where each side was left, so pressing again lands back on the same
# window instead of on whichever one happens to come first
space=$(printf '%s' "$windows" | jq -r --argjson c "$cur" '.[] | select(.id == $c) | .space')
printf '%s\n' "$cur" > "$CACHE/layer.$space.$from"

want=$(cat "$CACHE/layer.$space.$to" 2>/dev/null)
printf '%s\n' "$targets" | grep -qx "$want" || want=$(printf '%s\n' "$targets" | head -n1)

yabai -m window --focus "$want"
