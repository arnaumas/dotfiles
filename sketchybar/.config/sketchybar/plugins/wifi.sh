#!/usr/bin/env bash
source "$HOME/.config/sketchybar/plugins/hover.sh"
hover && exit 0

if [ -n "$(ipconfig getifaddr en0)" ]; then
	icon=󰖩
else
	icon=󰖪
fi
sketchybar --set "$NAME" icon="$icon" label.drawing=off
