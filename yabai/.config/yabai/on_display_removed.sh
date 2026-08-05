#!/usr/bin/env sh
# launchd PATH lacks /opt/homebrew/bin
export PATH="/opt/homebrew/bin:$PATH"
# Replay snapshot.sh's layout onto the main display: one new space per recorded
# external space, windows sorted back in. macOS has already dumped them onto one
# main space. Reconnect is left to macOS.

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/yabai"
FILE="$CACHE/layout.json"
PADDING="$HOME/.config/yabai/padding.sh"

[ -f "$FILE" ] || exit 0
layout=$(cat "$FILE")
n=$(printf '%s' "$layout" | jq 'length')
[ "$n" -gt 0 ] || exit 0

# let yabai re-register the dumped windows first
sleep 0.3

# --create appends to the focused space's display; make it main
main=$(yabai -m query --displays | jq -r '[.[] | select(.frame.x == 0 and .frame.y == 0)][0].index')
yabai -m display --focus "$main" 2>/dev/null

i=0
while [ "$i" -lt "$n" ]; do
	ids=$(printf '%s' "$layout" | jq -r ".[$i][]")
	i=$((i + 1))
	[ -z "$ids" ] && continue   # empty space: nothing to regroup

	yabai -m space --create
	sid=$(yabai -m query --spaces --display "$main" | jq -r '.[-1].index')
	for w in $ids; do
		yabai -m window "$w" --space "$sid" 2>/dev/null
	done
done

"$PADDING"
