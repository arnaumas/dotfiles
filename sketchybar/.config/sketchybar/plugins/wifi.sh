#!/usr/bin/env bash
if [ -n "$(ipconfig getifaddr en0)" ]; then
	icon=󰖩
else
	icon=󰖪
fi
sketchybar --set "$NAME" icon="$icon" label.drawing=off
