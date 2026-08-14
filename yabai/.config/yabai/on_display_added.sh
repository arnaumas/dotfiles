#!/usr/bin/env sh
. "$HOME/.config/yabai/lib.sh"
# put the external's spaces back in recorded order, windows included.
# no restore file => first attach: hand it main's last space instead.

FILE="$CACHE/layout.json"
PADDING="$HOME/.config/yabai/padding.sh"
SNAPSHOT="$HOME/.config/yabai/snapshot.sh"

# signal actions discard output; keep the last run's trace for debugging
mkdir -p "$CACHE"
exec >"$CACHE/display_added.log" 2>&1
echo "=== $(date '+%F %T') display_added"
trap yabai_unfreeze EXIT INT TERM
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

layout='{"ext":[],"main":[]}'
recorded=0
if [ -f "$RESTORE" ]; then
	layout=$(cat "$RESTORE")
	recorded=$(printf '%s' "$layout" | jq '.ext | length')
	rm -f "$RESTORE"
fi

focused=$(yabai_focused_index "$(yabai -m query --displays)")
created=''
order=''

# --create appends to the focused display
yabai -m display --focus "$ext" 2>/dev/null

i=0
while [ "$i" -lt "$recorded" ]; do
	e=$(printf '%s' "$layout" | jq -c ".ext[$i]")
	i=$((i + 1))
	orig=$(printf '%s' "$e" | jq -r .orig)
	tmp=$(printf '%s' "$e" | jq -r .uuid)
	spaces=$(yabai -m query --spaces)
	orig_at=$(printf '%s' "$spaces" | jq -r --arg u "$orig" '.[] | select(.uuid == $u) | .index')
	tmp_at=$(printf '%s' "$spaces" | jq -r --arg u "$tmp" '.[] | select(.uuid == $u) | .index')

	if [ -n "$orig_at" ] && [ "$orig" != "$tmp" ]; then
		# macOS brought the original back (monitor powered on): refill it, drop the stand-in
		for w in $(printf '%s' "$e" | jq -r '.windows[]'); do
			yabai -m window "$w" --space "$orig_at" 2>/dev/null
		done
		carrier=$orig
		if [ -n "$tmp_at" ]; then
			d=$(printf '%s' "$spaces" | jq -r --arg u "$tmp" '.[] | select(.uuid == $u) | .display')
			if [ "$(yabai -m query --spaces --display "$d" | jq 'length')" -gt 1 ]; then
				tmp_at=$(yabai -m query --spaces \
					| jq -r --arg u "$tmp" '.[] | select(.uuid == $u) | .index')
				yabai -m space "$tmp_at" --destroy
			fi
		fi
	elif [ -n "$tmp_at" ]; then
		carrier=$tmp
	elif [ -n "$orig_at" ]; then
		carrier=$orig
	else
		# gone both ways: rebuild it
		yabai -m space --create || continue
		new=$(yabai -m query --spaces --display "$ext" | jq -c '.[-1]')
		carrier=$(printf '%s' "$new" | jq -r .uuid)
		created="$created $carrier"
		sid=$(printf '%s' "$new" | jq -r .index)
		for w in $(printf '%s' "$e" | jq -r '.windows[]'); do
			yabai -m window "$w" --space "$sid" 2>/dev/null
		done
	fi

	# send it home; --display appends, so recorded order is rebuilt as we go
	cs=$(yabai -m query --spaces \
		| jq -r --arg u "$carrier" '.[] | select(.uuid == $u) | "\(.index) \(.display)"')
	[ -z "$cs" ] && continue
	if [ "${cs#* }" != "$ext" ]; then
		yabai -m space "${cs% *}" --display "$ext"
	fi
	order="$order $carrier"
done

if [ "$recorded" -eq 0 ]; then
	# first attach: macOS births an empty space on the new display, swap it for main's last
	real=$(yabai -m query --windows \
		| jq -c '[.[] | select(."has-ax-reference" and .scratchpad == "") | .id]')
	throwaway=$(yabai -m query --spaces --display "$ext" | jq -c --argjson real "$real" '
		if length == 1
		then {uuid: .[0].uuid, windows: [.[0].windows[] | select(IN($real[]))]}
		else empty end')
	donor_uuid=$(yabai -m query --spaces --display "$main" \
		| jq -r 'if length > 1 then .[-1].uuid else empty end')
	if [ -n "$throwaway" ] && [ -n "$donor_uuid" ]; then
		throwaway_uuid=$(printf '%s' "$throwaway" | jq -r .uuid)
		donor=$(yabai -m query --spaces \
			| jq -r --arg u "$donor_uuid" '.[] | select(.uuid == $u) | .index')
		if yabai -m space "$donor" --display "$ext"; then
			# the move renumbers every index; re-resolve both by uuid
			spaces=$(yabai -m query --spaces)
			donor=$(printf '%s' "$spaces" \
				| jq -r --arg u "$donor_uuid" '.[] | select(.uuid == $u) | .index')
			new=$(printf '%s' "$spaces" \
				| jq -r --arg u "$throwaway_uuid" '.[] | select(.uuid == $u) | .index')
			for w in $(printf '%s' "$throwaway" | jq -r '.windows[]'); do
				yabai -m window "$w" --space "$donor" 2>/dev/null
			done
			[ -n "$new" ] && yabai -m space "$new" --destroy
		fi
	fi
else
	# a space macOS restored itself can sit anywhere; walk the recorded order into place
	k=0
	for u in $order; do
		k=$((k + 1))
		ext_spaces=$(yabai -m query --spaces --display "$ext")
		at=$(printf '%s' "$ext_spaces" \
			| jq -r --arg u "$u" 'to_entries[] | select(.value.uuid == $u) | .key + 1')
		[ -z "$at" ] && continue
		[ "$at" -eq "$k" ] && continue
		idx=$(printf '%s' "$ext_spaces" | jq -r --arg u "$u" '.[] | select(.uuid == $u) | .index')
		target=$(printf '%s' "$ext_spaces" | jq -r --argjson k "$k" '.[$k - 1].index')
		yabai -m space "$idx" --move "$target"
	done

	# macOS's stand-ins: empty spaces matching neither the restore file nor what we made
	strays=$(yabai -m query --spaces | jq -r --argjson l "$layout" --arg c "$created" '
		($c | split(" ") | map(select(. != ""))) as $new
		| .[] | select((.windows | length) == 0
			and (IN(.uuid; $l.ext[].orig, $l.ext[].uuid, $l.main[], $new[]) | not)) | .uuid')
	for u in $strays; do
		s=$(yabai -m query --spaces \
			| jq -r --arg u "$u" '.[] | select(.uuid == $u) | "\(.index) \(.display)"')
		[ -z "$s" ] && continue
		[ "$(yabai -m query --spaces --display "${s#* }" | jq 'length')" -le 1 ] && continue
		yabai -m space "${s% *}" --destroy
	done
fi

case "$focused" in ''|null) ;; *) yabai -m display --focus "$focused" 2>/dev/null ;; esac

"$PADDING" --refresh
"$SNAPSHOT"

# the trap unfreezes the bar and draws once
exit 0
