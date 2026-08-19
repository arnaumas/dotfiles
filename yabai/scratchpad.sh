#!/usr/bin/env sh
. "$HOME/.config/yabai/lib.sh"
# summon or dismiss a labelled scratchpad; launch the app on first use.
# usage: scratchpad.sh <label> <launch command...>

label="$1"
shift

# center the summoned window on the current display, keeping its own size
center() {
	win="$(yabai -m query --windows | jq -c --arg l "$label" \
		'[.[] | select(.scratchpad == $l and ."is-visible")][0] // empty')"
	[ -n "$win" ] || return 1
	pos="$(yabai -m query --displays --display | jq -r --argjson w "$win" '
		.frame as $d | $w.frame as $f |
		"abs:\($d.x + ($d.w - $f.w) / 2 | floor):\($d.y + ($d.h - $f.h) / 2 | floor)"')"
	yabai -m window "$(printf '%s' "$win" | jq -r .id)" --move "$pos"
}

# --toggle fires no yabai signal; on first use window_created covers it
if yabai -m window --toggle "$label" 2>/dev/null; then
	center
	sketchybar --trigger yabai_windows_change 2>/dev/null
	exit 0
fi
exec "$@"
