#!/usr/bin/env sh
. "$HOME/.config/yabai/lib.sh"
# macOS births a fresh empty space on every newly attached display. Hand the external
# the last space of the main display instead (windows and label included) and destroy
# the throwaway. Move first: a display must never be left with zero spaces.

PADDING="$HOME/.config/yabai/padding.sh"
SNAPSHOT="$HOME/.config/yabai/snapshot.sh"

# signal actions discard output; keep the last run's trace for debugging
mkdir -p "$CACHE"
exec >"$CACHE/display_added.log" 2>&1
echo "=== $(date '+%F %T') display_added"
set -x

# display_added can beat macOS to creating the space: poll instead of guessing a sleep
i=0
while [ "$i" -lt 30 ]; do
	displays=$(yabai -m query --displays)
	main=$(yabai_main_index "$displays")
	case "$main" in ''|null) main=0 ;; esac
	ext=$(yabai_other_index "$displays" "$main")
	case "$ext" in ''|null) ;; *)
		[ "$(yabai -m query --spaces --display "$ext" | jq 'length')" -gt 0 ] && break ;;
	esac
	i=$((i + 1))
	sleep 0.2
done
case "$ext" in ''|null) exit 0 ;; esac

# settle: macOS can still be shuffling spaces right after the space appears
sleep 0.3

# the throwaway: macOS's new space on the external. Its window list carries ghosts from
# the unplug, so keep only live windows; scratchpads are excluded as in snapshot.sh.
real=$(yabai -m query --windows \
	| jq -c '[.[] | select(."has-ax-reference" and .scratchpad == "") | .id]')
throwaway=$(yabai -m query --spaces --display "$ext" | jq -c --argjson real "$real" '
	if length == 1
	then {uuid: .[0].uuid, windows: [.[0].windows[] | select(IN($real[]))]}
	else empty end')
[ -z "$throwaway" ] && exit 0
throwaway_uuid=$(printf '%s' "$throwaway" | jq -r .uuid)

# the donor: main's last space, provided main keeps at least one of its own
donor_uuid=$(yabai -m query --spaces --display "$main" \
	| jq -r 'if length > 1 then .[-1].uuid else empty end')
[ -z "$donor_uuid" ] && exit 0
donor=$(yabai -m query --spaces | jq -r --arg u "$donor_uuid" '.[] | select(.uuid == $u) | .index')

yabai -m space "$donor" --display "$ext" || exit 0

# the move renumbers every index; re-resolve both spaces by uuid, from one query
spaces=$(yabai -m query --spaces)
donor=$(printf '%s' "$spaces" | jq -r --arg u "$donor_uuid" '.[] | select(.uuid == $u) | .index')
new=$(printf '%s' "$spaces" | jq -r --arg u "$throwaway_uuid" '.[] | select(.uuid == $u) | .index')

# hand over any live windows before dropping the throwaway; the ghosts die with it
for w in $(printf '%s' "$throwaway" | jq -r '.windows[]'); do
	yabai -m window "$w" --space "$donor" 2>/dev/null
done
[ -n "$new" ] && yabai -m space "$new" --destroy

"$PADDING" --refresh
"$SNAPSHOT"

# no yabai event covers a space or window changing display; reaching here means one did
sketchybar --trigger yabai_spaces_change 2>/dev/null
