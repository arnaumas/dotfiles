#!/usr/bin/env sh
# yabai runs signal/script actions under launchd PATH (no /opt/homebrew/bin),
# so yabai/jq are not found unless we add it here.
export PATH="/opt/homebrew/bin:$PATH"
# ultrawide auto-padding: side margins scale with window count on the 3440 panel.
# every other space gets flat BASE padding, so a space keeps sane padding after
# being moved between displays (or after the ultrawide is unplugged).

W=3440
BASE=8
TOP=14   # ultrawide has no notch; compensates so the gap below the bar matches

wide=$(yabai -m query --displays | jq -r ".[] | select(.frame.w==$W) | .index")
wins=$(yabai -m query --windows)

yabai -m query --spaces | jq -r '.[] | "\(.index) \(.display)"' | while read -r sid did; do
	if [ "$did" = "$wide" ]; then
		n=$(printf '%s' "$wins" | jq --argjson s "$sid" \
			'[.[] | select(.space==$s and .["is-floating"]==false
				and .["has-ax-reference"]==true and .subrole=="AXStandardWindow"
				and .scratchpad=="")] | length')
		case "$n" in
			0|1) side=$(( (W - W/3) / 2 )) ;;   # 1/3 width -> 1147
			2)   side=$(( (W - W*2/3) / 2 )) ;;  # 2/3 width -> 573
			*)   side=$BASE ;;
		esac
		top=$TOP
	else
		side=$BASE
		top=$BASE
	fi
	yabai -m config --space "$sid" \
		top_padding "$top" bottom_padding "$BASE" \
		left_padding "$side" right_padding "$side"
done
