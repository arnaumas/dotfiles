#!/usr/bin/env bash
source "$HOME/.config/sketchybar/plugins/hover.sh"

# dismiss the output picker once the pointer leaves the bar
if [ "$SENDER" = "mouse.exited.global" ]; then
	sketchybar --set "$NAME" popup.drawing=off
	exit 0
fi

hover && exit 0

# Speaker glyphs are nf-fa (BMP private-use); paste them in below, tooling strips them.
# spkr=nf-fa-volume_high  spkr_mute=nf-fa-volume_xmark
spkr=
spkr_mute=
# Headphone glyphs are MDI (md-headphones / md-headphones_off).
phones=󰋋
phones_mute=󰟎

# Headphones only for AirPods; every other output (built-in speakers, the AOC
# monitor over HDMI) gets the speaker glyph. Matched on the device name because
# system_profiler's Transport field is far too slow for a 10s update.
case "$(SwitchAudioSource -c)" in
*AirPods*) on=$phones off=$phones_mute ;;
*) on=$spkr off=$spkr_mute ;;
esac

if [ "$(osascript -e 'output muted of (get volume settings)')" = "true" ]; then
	icon=$off
else
	icon=$on
fi

sketchybar --set "$NAME" icon="$icon" label.drawing=off
