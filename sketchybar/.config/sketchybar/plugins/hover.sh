#!/usr/bin/env bash
source "$HOME/.config/sketchybar/style.sh"

# Sourced by item scripts: highlight the focused-space pill on hover.
# Returns 0 (handled) on a mouse event so the caller can `hover && exit 0`.
hover() {
	case "$SENDER" in
	mouse.entered)
		sketchybar --set "$NAME" background.drawing=on background.color="$HL_BG"
		return 0
		;;
	mouse.exited)
		sketchybar --set "$NAME" background.drawing=off
		return 0
		;;
	esac
	return 1
}

# Executed directly as a space pill's script: focus-aware, so leaving the
# active pill keeps it lit (yabai is the source of truth for focus).
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
	case "$SENDER" in
	mouse.entered)
		sketchybar --set "$NAME" background.drawing=on background.color="$HL_BG"
		;;
	mouse.exited)
		state=$(yabai -m query --spaces --space "${NAME#space.}" |
			jq -r 'if .["has-focus"] then "focused" elif .["is-visible"] then "visible" else "off" end')
		case "$state" in
		focused) ;; # leaving the focused pill keeps it lit
		visible) sketchybar --set "$NAME" background.drawing=on background.color="$BG" ;;
		*) sketchybar --set "$NAME" background.drawing=off ;;
		esac
		;;
	esac
fi
