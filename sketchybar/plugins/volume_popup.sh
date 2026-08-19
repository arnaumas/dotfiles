#!/usr/bin/env bash
# Output-device picker for the volume item, drawn as a sketchybar popup.
#
# Control Center popovers are not an option here: they anchor to the position of
# the menu bar item, and the menu bar is hidden, so the AXPress succeeds (exit 0)
# and nothing is ever drawn. A sketchybar popup lives in sketchybar's own window,
# so it does not care.
#
# Never source hover.sh from this file: it runs as a click_script, which inherits
# a stale SENDER=mouse.entered (see the comment in hover.sh).

CONFIG="$HOME/.config/sketchybar"
source "$CONFIG/style.sh"

SELF="$CONFIG/plugins/volume_popup.sh"

case "$1" in
close)
	sketchybar --set volume popup.drawing=off
	exit 0
	;;
select)
	SwitchAudioSource -s "$2" >/dev/null
	sketchybar --set volume popup.drawing=off
	# refresh the icon through the event rather than by calling volume.sh: a
	# direct call would inherit the stale SENDER and be swallowed by hover()
	sketchybar --trigger volume_change
	exit 0
	;;
esac

# rebuilt on every open, so devices connected since the last one show up
while IFS= read -r item; do
	[ -n "$item" ] && sketchybar --remove "$item"
done < <(sketchybar --query volume | jq -r '.popup.items[]?')

current=$(SwitchAudioSource -c)

args=()
i=0
while IFS= read -r dev; do
	i=$((i + 1))
	name="volume.dev.$i"
	if [ "$dev" = "$current" ]; then mark=✓; else mark=" "; fi
	args+=(
		--add item "$name" popup.volume
		--set "$name" label="$dev" icon="$mark"
		icon.padding_left=8 icon.padding_right=6
		label.padding_left=0 label.padding_right=8
		click_script="$SELF select \"$dev\""
	)
done < <(SwitchAudioSource -a -t output)

sketchybar "${args[@]}" --set volume popup.drawing=toggle
