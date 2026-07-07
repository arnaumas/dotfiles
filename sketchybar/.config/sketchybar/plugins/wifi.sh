#!/usr/bin/env bash
source "$HOME/.config/sketchybar/style.sh"

# click ($1): open Wi-Fi settings. hover (SENDER): highlight the focused-space pill.
if [ "$1" = "click" ]; then
	open "x-apple.systempreferences:com.apple.wifi-settings-extension"
	exit 0
fi

case "$SENDER" in
mouse.entered)
	sketchybar --set "$NAME" background.drawing=on background.color="$HL_BG"
	exit 0
	;;
mouse.exited)
	sketchybar --set "$NAME" background.drawing=off
	exit 0
	;;
esac

if [ -n "$(ipconfig getifaddr en0)" ]; then
	icon=󰖩
else
	icon=󰖪
fi
sketchybar --set "$NAME" icon="$icon" label.drawing=off
