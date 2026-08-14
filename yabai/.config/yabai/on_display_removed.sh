#!/usr/bin/env sh
. "$HOME/.config/yabai/lib.sh"
# Replay snapshot.sh's layout onto the main display: one new space per recorded
# external space, windows sorted back in. macOS has already dumped them onto one
# main space. Reconnect is left to macOS.

FILE="$CACHE/layout.json"
PADDING="$HOME/.config/yabai/padding.sh"

# signal actions discard output; keep the last run's trace for debugging
mkdir -p "$CACHE"
exec >"$CACHE/display_removed.log" 2>&1
echo "=== $(date '+%F %T') display_removed"
set -x

[ -f "$FILE" ] || exit 0
layout=$(cat "$FILE")
n=$(printf '%s' "$layout" | jq 'length')
[ "$n" -gt 0 ] || exit 0

# let yabai re-register the dumped windows first
sleep 0.3

# --create appends to the focused space's display; make it main
main=$(yabai_main_index "$(yabai -m query --displays)")
yabai -m display --focus "$main" 2>/dev/null

i=0
moved=0
while [ "$i" -lt "$n" ]; do
	ids=$(printf '%s' "$layout" | jq -r ".[$i][]")
	i=$((i + 1))
	[ -z "$ids" ] && continue   # empty space: nothing to regroup

	yabai -m space --create
	sid=$(yabai -m query --spaces --display "$main" | jq -r '.[-1].index')
	for w in $ids; do
		yabai -m window "$w" --space "$sid" 2>/dev/null && moved=1
	done
done

"$PADDING" --refresh

# window --space fires no yabai signal; only tell the bar if something actually moved
[ "$moved" -eq 1 ] && sketchybar --trigger yabai_spaces_change 2>/dev/null
