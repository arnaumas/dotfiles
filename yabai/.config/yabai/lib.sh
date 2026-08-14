#!/usr/bin/env sh
# Sourced by every script here. launchd PATH lacks /opt/homebrew/bin.
export PATH="/opt/homebrew/bin:$PATH"

CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/yabai"
# display count the bar is allowed to draw; sketchybar's spaces plugin freezes on mismatch
GATE="$CACHE/bar_displays"

# helpers take `yabai -m query --displays` output as $1, so callers query once

# main = the display at the global origin (carries the menu bar)
yabai_main_index() {
	printf '%s' "$1" | jq -r '[.[] | select(.frame.x == 0 and .frame.y == 0)][0].index'
}

yabai_other_index() {
	printf '%s' "$1" | jq -r --arg i "$2" '[.[] | select(.index != ($i | tonumber))][0].index'
}

yabai_focused_index() {
	printf '%s' "$1" | jq -r '.[] | select(."has-focus") | .index'
}
