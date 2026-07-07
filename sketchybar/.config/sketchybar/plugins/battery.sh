#!/usr/bin/env bash
info=$(pmset -g batt)
pct=$(grep -Eo "[0-9]+%" <<<"$info" | tr -d '%')
[ -z "$pct" ] && exit 0

charging=no
grep -q "AC Power" <<<"$info" && charging=yes

if [ "$charging" = yes ]; then
	icon=󰂄
else
	case "$pct" in
		100|9[0-9]) icon=󰁹 ;;
		8[0-9]|7[0-9]) icon=󰂀 ;;
		6[0-9]|5[0-9]) icon=󰁾 ;;
		4[0-9]|3[0-9]) icon=󰁼 ;;
		2[0-9]) icon=󰁻 ;;
		*) icon=󰁺 ;;
	esac
fi

sketchybar --set "$NAME" icon="$icon" label="${pct}%"
