#!/usr/bin/env sh
# skhd runs bindings under launchd PATH (no /opt/homebrew/bin), same as yabai signals.
export PATH="/opt/homebrew/bin:$PATH"
# summon or dismiss a labelled scratchpad; launch the app on first use.
# usage: scratchpad.sh <label> <launch command...>

label="$1"
shift

yabai -m window --toggle "$label" 2>/dev/null || exec "$@"
