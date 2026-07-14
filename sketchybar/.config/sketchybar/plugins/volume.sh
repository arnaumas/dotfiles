#!/usr/bin/env bash
source "$HOME/.config/sketchybar/plugins/hover.sh"
hover && exit 0

# click ($1): open the Control Center Sound popover.
# Needs Accessibility permission for sketchybar and Sound pinned to the menu bar.
# NAME_MATCH is the localized Sound module description (verify with the enumerate
# one-liner once Accessibility is granted).
if [ "$1" = "click" ]; then
	osascript -e 'tell application "System Events" to tell process "ControlCenter" to click (menu bar item 1 of menu bar 1 whose description contains "So")'
	exit 0
fi

# Speaker glyphs are nf-fa (BMP private-use); paste them in below, tooling strips them.
# spkr=nf-fa-volume_high  spkr_mute=nf-fa-volume_xmark
spkr=
spkr_mute=
# Headphone glyphs are MDI (md-headphones / md-headphones_off).
phones=󰋋
phones_mute=󰟎

# Internal speakers report "... Speakers"; anything else counts as headphones.
case "$(SwitchAudioSource -c)" in
*Speakers) on=$spkr off=$spkr_mute ;;
*) on=$phones off=$phones_mute ;;
esac

if [ "$(osascript -e 'output muted of (get volume settings)')" = "true" ]; then
	icon=$off
else
	icon=$on
fi

sketchybar --set "$NAME" icon="$icon" label.drawing=off
