#!/usr/bin/env bash
source "$HOME/.config/sketchybar/plugins/hover.sh"
hover && exit 0

sketchybar --set "$NAME" label="$(date '+%a %d %b %H:%M')"
