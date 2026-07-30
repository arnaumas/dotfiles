#!/usr/bin/env sh
# yabai runs signal/script actions under launchd PATH (no /opt/homebrew/bin),
# so yabai/jq/osascript are not found unless we add it here.
export PATH="/opt/homebrew/bin:$PATH"

# Per-display auto-padding, two independent concerns.
#
# top: the gap under sketchybar depends on the menu-bar/notch height, which macOS
# measures in POINTS and changes with a display's scaling. Only ONE display carries
# the OS menu bar (the main display); the rest report menu-bar height 0.
#
#   - main display (menu-bar > 0): top_padding = ANCHOR - menubar_height. Tracks the
#     scaling automatically, so re-scaling the built-in no longer squishes the gap.
#     ANCHOR is calibrated so the built-in (menu-bar 38pt) keeps top_padding = BASE.
#   - secondary display (menu-bar == 0): no OS menu bar, but sketchybar + external_bar
#     still occupy a fixed footprint there regardless of that display's resolution.
#     Measured geometry (bar bottom at y_offset+height=38, external_bar reserves 32):
#         effective_gap = top_padding - 6 - border_width/2   (border straddles the edge)
#     With the 4pt jankyborders width, SECONDARY=14 -> 6pt effective gap, matching the
#     window_gap spacing (10 - 2*2). Nudge SECONDARY point-for-point to taste.
#
# side: centering. only the ultrawide 3440 panel gets side margins scaled by window
# count. every other space keeps flat BASE, so a space keeps sane padding after
# being moved between displays (or after the ultrawide is unplugged).

W=3440
BASE=8
ANCHOR=46
SECONDARY=14

# menu-bar height per display, keyed by CGDirectDisplayID (== yabai display .id).
# NSScreen.frame vs .visibleFrame differ by the menu bar at the top edge (and the
# taller notch reservation); the top-edge delta is exactly what we want.
MB=$(osascript -l JavaScript -e '
ObjC.import("AppKit");
$.NSScreen.screens.js.map(s => {
  const id = s.deviceDescription.objectForKey($("NSScreenNumber")).unsignedIntValue;
  const f = s.frame, v = s.visibleFrame;
  return id + " " + Math.round((f.origin.y + f.size.height) - (v.origin.y + v.size.height));
}).join("\n")')

displays=$(yabai -m query --displays)
wins=$(yabai -m query --windows)
wide=$(printf '%s' "$displays" | jq -r ".[] | select(.frame.w==$W) | .index")

yabai -m query --spaces | jq -r '.[] | "\(.index) \(.display)"' | while read -r sid did; do
	# top: main display scales with its menu-bar height; secondary uses a constant
	id=$(printf '%s' "$displays" | jq -r ".[] | select(.index==$did) | .id")
	mb=$(printf '%s\n' "$MB" | while read -r mid mh; do [ "$mid" = "$id" ] && echo "$mh"; done)
	if [ -n "$mb" ] && [ "$mb" -gt 0 ]; then
		top=$(( ANCHOR - mb ))
	else
		top=$SECONDARY
	fi
	[ "$top" -lt "$BASE" ] && top=$BASE

	# side: centering only on the ultrawide, scaled by window count
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
	else
		side=$BASE
	fi

	yabai -m config --space "$sid" \
		top_padding "$top" bottom_padding "$BASE" \
		left_padding "$side" right_padding "$side"
done
