#!/usr/bin/env sh
. "$HOME/.config/yabai/lib.sh"
# Mirror the external display's space layout to disk; on_display_removed.sh
# replays it (macOS destroys the spaces before yabai can read them).

FILE="$CACHE/layout.json"

displays=$(yabai -m query --displays)
# with <2 displays the external is gone; writing would clobber the snapshot
[ "$(printf '%s' "$displays" | jq 'length')" -lt 2 ] && exit 0

main=$(yabai_main_index "$displays")
case "$main" in ''|null) exit 0 ;; esac
ext=$(yabai_other_index "$displays" "$main")
case "$ext" in ''|null) exit 0 ;; esac

# external spaces in order, each an array of window ids. Hidden scratchpads sit in a
# space's window list but belong to no space; recording one drags it into a rebuilt space.
keep=$(yabai -m query --windows | jq -c '[.[] | select(.scratchpad == "") | .id]')
layout=$(yabai -m query --spaces --display "$ext" | jq -c --argjson keep "$keep" \
	'[.[] | [.windows[] | select(IN($keep[]))]]')

mkdir -p "$CACHE"
printf '%s\n' "$layout" > "$FILE"
