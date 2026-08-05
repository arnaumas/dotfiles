#!/usr/bin/env bash
source "$HOME/.config/sketchybar/plugins/hover.sh"
hover && exit 0

# Now playing (Music.app only, via AppleScript). MediaRemote is gated on
# macOS 15.4+, so sketchybar's media_change event is not used here.
#
# Runs once a second to drive the marquee, but only talks to Music every
# REFRESH ticks; the rest come out of the state cache.

# launchd gives us a byte-oriented shell: without a UTF-8 locale ${s:i:n}
# slices accented titles mid-character.
export LC_ALL=en_US.UTF-8

STATE="${TMPDIR:-/tmp}/sketchybar_media"
WIDTH=28  # visible label width, in characters
GAP="   "  # separator between the end of the text and its repeat
REFRESH=5  # ticks between AppleScript queries
HOLD=3     # extra ticks spent at offset 0 before scrolling away

# Play/pause glyphs are MDI (md-pause / md-play). The icon shows the *action*,
# not the state: it is a button.
pause=󰏤
play=󰐊

hide() {
	rm -f "$STATE"
	sketchybar --set "$NAME" drawing=off
	exit 0
}

# Never launch Music just to ask it what is playing.
pgrep -xq Music || hide

# click ($1): toggle playback, then fall through to redraw immediately.
if [ "$1" = "click" ]; then
	osascript -e 'tell application "Music" to playpause' >/dev/null 2>&1
	rm -f "$STATE"
fi

# cache: state<TAB>text<TAB>offset<TAB>ticks_since_fetch
tick=$REFRESH
if [ -f "$STATE" ]; then
	IFS=$'\t' read -r pstate text offset tick <"$STATE"
	tick=$((tick + 1))
fi

if [ "$tick" -ge "$REFRESH" ]; then
	info=$(osascript <<-'EOF' 2>/dev/null
		tell application "Music"
			if it is running then
				set s to player state as text
				if s is "stopped" then return "stopped"
				return s & tab & (name of current track) & tab & (album of current track)
			end if
		end tell
	EOF
	)
	[ -z "$info" ] && hide

	IFS=$'\t' read -r pstate title album <<<"$info"
	case "$pstate" in
	playing | paused) ;;
	*) hide ;;
	esac

	if [ -n "$album" ]; then
		new_text="$title · $album"
	else
		new_text="$title"
	fi
	# A track change restarts the marquee; a pause does not.
	[ "$new_text" != "$text" ] && offset=0
	text=$new_text
	tick=0
fi

[ -z "$text" ] && hide

if [ "$pstate" = playing ]; then
	icon=$pause
else
	icon=$play
fi

# Short enough to fit: no scrolling, no state to advance. The item keeps a
# constant width because label.width is pinned in sketchybarrc, not by padding.
if [ "${#text}" -le "$WIDTH" ]; then
	label=$text
	offset=0
else
	scroll="${text}${GAP}"
	period=${#scroll}
	# Hold at the start, then advance one character per tick. The window wraps,
	# so the tail of the string is followed by the gap and then its own head.
	if [ "$offset" -lt 0 ]; then
		label="${scroll:0:WIDTH}"
		offset=$((offset + 1))
	else
		label="${scroll:offset:WIDTH}"
		if [ "${#label}" -lt "$WIDTH" ]; then
			label="${label}${scroll:0:$((WIDTH - ${#label}))}"
		fi
		offset=$((offset + 1))
		[ "$offset" -ge "$period" ] && offset=$((-HOLD))
	fi
	# Paused tracks sit still.
	[ "$pstate" != playing ] && offset=$((offset - 1))
fi

printf '%s\t%s\t%s\t%s\n' "$pstate" "$text" "$offset" "$tick" >"$STATE"

sketchybar --set "$NAME" drawing=on icon="$icon" label="$label"
