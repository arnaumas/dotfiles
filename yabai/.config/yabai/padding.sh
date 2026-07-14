#!/usr/bin/env sh
# yabai runs signal/script actions under launchd PATH (no /opt/homebrew/bin),
# so yabai/jq are not found unless we add it here.
export PATH="/opt/homebrew/bin:$PATH"
# ultrawide auto-padding: side margins scale with window count on the 3440 panel.
# 1 win -> 1/3 width, 2 -> 2/3, 3+ -> full. top_padding 12 compensates for the
# missing notch so the gap below the bar matches the built-in (6px).

W=3440
BASE=8
TOP=14

disp=$(yabai -m query --displays | jq -r ".[] | select(.frame.w==$W) | .index")
[ -z "$disp" ] && exit 0

for sid in $(yabai -m query --spaces --display "$disp" | jq -r '.[].index'); do
	n=$(yabai -m query --windows --space "$sid" \
			| jq '[.[] | select(.["is-floating"]==false and .["has-ax-reference"]==true and .subrole=="AXStandardWindow")] | length')
	case "$n" in
		0|1) side=$(( (W - W/3) / 2 )) ;;      # 1/3 width  -> 1147
		2)   side=$(( (W - W*2/3) / 2 )) ;;     # 2/3 width  -> 573
		*)   side=$BASE ;;                       # full       -> 6
	esac
	yabai -m config --space "$sid" \
		top_padding "$TOP" bottom_padding "$BASE" \
		left_padding "$side" right_padding "$side"
done
