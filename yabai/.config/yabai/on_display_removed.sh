#!/usr/bin/env sh
. "$HOME/.config/yabai/lib.sh"
# macOS merges the external's windows into a main space; give them their own spaces back
# and leave on_display_added.sh a restore file naming both uuids.

FILE="$CACHE/layout.json"
PADDING="$HOME/.config/yabai/padding.sh"

# signal actions discard output; keep the last run's trace for debugging
mkdir -p "$CACHE"
exec >"$CACHE/display_removed.log" 2>&1
echo "=== $(date '+%F %T') display_removed"
trap yabai_unfreeze EXIT INT TERM
set -x

# the end state is known: one display, so the separators go. Drawing it now means the bar
# settles immediately instead of after the rebuild.
for it in $(sketchybar --query bar 2>/dev/null \
	| jq -r '.items[] | select(startswith("space.sep."))'); do
	sketchybar --remove "$it" 2>/dev/null
done

[ -f "$FILE" ] || exit 0
layout=$(cat "$FILE")
n=$(printf '%s' "$layout" | jq '.ext | length')
[ "$n" -gt 0 ] || exit 0

# let yabai re-register the merged windows first
sleep 0.3

# --create appends to the focused display
main=$(yabai_main_index "$(yabai -m query --displays)")
yabai -m display --focus "$main" 2>/dev/null

rebuilt='[]'
i=0
while [ "$i" -lt "$n" ]; do
	space=$(printf '%s' "$layout" | jq -c ".ext[$i]")
	i=$((i + 1))
	u=$(printf '%s' "$space" | jq -r .uuid)

	# survivor: macOS carried the whole space over, windows included
	if yabai -m query --spaces | jq -e --arg u "$u" 'any(.[].uuid; . == $u)' >/dev/null; then
		rebuilt=$(printf '%s' "$rebuilt" | jq -c --argjson s "$space" \
			'. + [{orig: $s.uuid, uuid: $s.uuid, windows: $s.windows}]')
		continue
	fi

	yabai -m space --create || continue
	last=$(yabai -m query --spaces --display "$main" | jq -c '.[-1]')
	sid=$(printf '%s' "$last" | jq -r .index)
	for w in $(printf '%s' "$space" | jq -r '.windows[]'); do
		yabai -m window "$w" --space "$sid" 2>/dev/null
	done
	rebuilt=$(printf '%s' "$rebuilt" | jq -c --argjson s "$space" \
		--arg u "$(printf '%s' "$last" | jq -r .uuid)" \
		'. + [{orig: $s.uuid, uuid: $u, windows: $s.windows}]')
done

# survivors land wherever macOS dropped them; walk the external's order into the tail of main
cnt=$(printf '%s' "$rebuilt" | jq 'length')
k=0
for u in $(printf '%s' "$rebuilt" | jq -r '.[].uuid'); do
	k=$((k + 1))
	spaces=$(yabai -m query --spaces --display "$main")
	total=$(printf '%s' "$spaces" | jq 'length')
	want=$((total - cnt + k))
	[ "$want" -lt 1 ] && continue
	at=$(printf '%s' "$spaces" | jq -r --arg u "$u" 'to_entries[] | select(.value.uuid == $u) | .key + 1')
	[ -z "$at" ] && continue
	[ "$at" -eq "$want" ] && continue
	idx=$(printf '%s' "$spaces" | jq -r --arg u "$u" '.[] | select(.uuid == $u) | .index')
	target=$(printf '%s' "$spaces" | jq -r --argjson w "$want" '.[$w - 1].index')
	[ -n "$target" ] && yabai -m space "$idx" --move "$target"
done

# own file: snapshot.sh rewrites layout.json the moment the display returns
printf '%s' "$layout" | jq -c --argjson e "$rebuilt" '.ext = $e' > "$RESTORE"

"$PADDING" --refresh
# the trap unfreezes the bar and draws once
