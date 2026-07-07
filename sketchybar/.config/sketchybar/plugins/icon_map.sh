#!/usr/bin/env bash
# app name (yabai .app) -> nerd font glyph. Extend as needed.

icon_for_app () {
	case "$1" in
		"Safari"|"Helium"|"Google Chrome"|"Firefox") echo "󰖟" ;;
		"Mail") echo "󰇮" ;;
		"Ghostty"|"Terminal"|"iTerm2"|"kitty"|"Alacritty") echo "" ;;
		"sioyek"|"Preview"|"Skim") echo "" ;;
		"JabRef") echo "" ;;
		"Music"|"Música"|"Spotify") echo "󰎈" ;;
		"Finder") echo "󰀶" ;;
		"Calculator") echo "󰪚" ;;
		"System Settings"|"Configuració del Sistema") echo "" ;;
		*) echo "󰣆" ;;
	esac
}
