#!/usr/bin/env bash
# Dumb renderer: mirror yabai's spaces into sketchybar items. yabai is the
# source of truth (labels come from the topic script); sketchybar knows nothing
# about topics. Run on every yabai_spaces_change / yabai_windows_change trigger.

CONFIG="$HOME/.config/sketchybar"
source "$CONFIG/colors.sh"
source "$CONFIG/plugins/icon_map.sh"

HEIGHT=32

# items sketchybar currently has
all_items=$(sketchybar --query bar | jq -r '.items[]')
existing=$(grep '^space\.' <<<"$all_items" || true)

desired=()

while IFS=$'\t' read -r index label focus; do
	name="space.$index"
	desired+=("$name")

	# app-icon glyphs for the windows on this space
	glyphs=""
	while IFS= read -r app; do
		[ -n "$app" ] && glyphs+="$(icon_for_app "$app") "
	done < <(yabai -m query --windows --space "$index" | jq -r '.[].app' | sort -u)
	glyphs="${glyphs% }"

	# label = topic name (fallback to index) + app glyphs
	text="${label:-$index}"
	[ -n "$glyphs" ] && text="$text $glyphs"

	# create on first sight
	if ! grep -qx "$name" <<<"$existing"; then
		sketchybar --add item "$name" left \
			--set "$name" icon.drawing=off \
				label.padding_left=8 label.padding_right=8 \
				click_script="yabai -m space --focus $index"
	fi

	# label + focus highlight
	if [ "$focus" = "true" ]; then
		sketchybar --set "$name" label="$text" \
			background.drawing=on background.color="$HL_BG"
	else
		sketchybar --set "$name" label="$text" background.drawing=off
	fi
done < <(yabai -m query --spaces | jq -r '.[] | "\(.index)\t\(.label)\t\(.["has-focus"])"')

# drop items for spaces that no longer exist
while IFS= read -r name; do
	[ -z "$name" ] && continue
	keep=false
	for d in "${desired[@]}"; do [ "$d" = "$name" ] && keep=true && break; done
	$keep || sketchybar --remove "$name"
done <<<"$existing"

# rebuild the bracket only when membership changes (avoids flicker)
state="${TMPDIR:-/tmp}/sketchybar_spaces_members"
new_members="${desired[*]}"
old_members=$(cat "$state" 2>/dev/null || true)
if [ "$new_members" != "$old_members" ] || ! grep -qx spaces <<<"$all_items"; then
	sketchybar --remove spaces 2>/dev/null
	if [ ${#desired[@]} -gt 0 ]; then
		sketchybar --add bracket spaces "${desired[@]}" \
			--set spaces background.color="$BASE" background.corner_radius=20 \
				background.height="$HEIGHT" background.border_color="$BG" \
				background.border_width=2 \
				background.padding_left=8 background.padding_right=8
	fi
	printf '%s' "$new_members" >"$state"
fi
