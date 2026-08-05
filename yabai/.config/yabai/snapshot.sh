#!/usr/bin/env sh
# launchd PATH lacks /opt/homebrew/bin
export PATH="/opt/homebrew/bin:$PATH"
# Mirror the external display's space layout to disk; on_display_removed.sh
# replays it (macOS destroys the spaces before yabai can read them).

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/yabai"
FILE="$CACHE/layout.json"

displays=$(yabai -m query --displays)
# with <2 displays the external is gone; writing would clobber the snapshot
[ "$(printf '%s' "$displays" | jq 'length')" -lt 2 ] && exit 0

ext=$(printf '%s' "$displays" | jq -r '[.[] | select(.frame.x != 0 or .frame.y != 0)][0].index')
[ -z "$ext" ] || [ "$ext" = "null" ] && exit 0

# external spaces in order, each an array of window ids
layout=$(yabai -m query --spaces --display "$ext" | jq -c '[.[] | .windows]')

mkdir -p "$CACHE"
printf '%s\n' "$layout" > "$FILE"
