#!/usr/bin/env bash
source "$HOME/.config/sketchybar/plugins/hover.sh"
hover && exit 0

# click ($1): open the Wi-Fi settings pane.
if [ "$1" = "click" ]; then
	open "x-apple.systempreferences:com.apple.wifi-settings-extension"
	exit 0
fi

if [ -n "$(ipconfig getifaddr en0)" ]; then
	icon=󰖩
else
	icon=󰖪
fi
sketchybar --set "$NAME" icon="$icon" label.drawing=off
