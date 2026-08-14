#!/usr/bin/env sh
. "$HOME/.config/yabai/lib.sh"
# summon or dismiss a labelled scratchpad; launch the app on first use.
# usage: scratchpad.sh <label> <launch command...>

label="$1"
shift

# --toggle fires no yabai signal; on first use window_created covers it
if yabai -m window --toggle "$label" 2>/dev/null; then
	sketchybar --trigger yabai_windows_change 2>/dev/null
	exit 0
fi
exec "$@"
