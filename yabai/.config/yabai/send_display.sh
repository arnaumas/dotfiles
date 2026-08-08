#!/usr/bin/env sh
# skhd runs bindings under launchd PATH (no /opt/homebrew/bin), same as yabai signals.
export PATH="/opt/homebrew/bin:$PATH"
# send the focused window to the other display and follow it.
# hyper + shift - m sends the whole space; this sends just the window.

displays=$(yabai -m query --displays)
[ "$(printf '%s' "$displays" | jq 'length')" -lt 2 ] && exit 0

win=$(yabai -m query --windows --window) || exit 0
[ -z "$win" ] && exit 0

cur=$(printf '%s' "$displays" | jq -r '.[] | select(."has-focus") | .index')
target=$(printf '%s' "$displays" | jq -r --argjson c "$cur" '[.[] | select(.index != $c)] | first | .index')

if [ "$(printf '%s' "$win" | jq -r '."is-floating"')" != "true" ]; then
	# warp.sh leaves window_insertion_point/window_placement set to whatever the
	# last cross-display warp used. there is no direction here, so put them back
	# to the yabai/yabairc defaults before letting the window land.
	yabai -m config window_insertion_point focused
	yabai -m config window_placement second_child
	yabai -m window --display "$target" --focus
	exit 0
fi

# --display retiles a floating window: it comes back is-floating false with a
# tile frame. so move it by frame instead. the space reassignment is what
# carries it across; it preserves the float but leaves the frame addressing the
# old display, so --move has to fix up the coordinates afterwards.
id=$(printf '%s' "$win" | jq -r '.id')
space=$(yabai -m query --spaces --display "$target" | jq -r '.[] | select(."is-visible") | .index')

# mirror its relative position into the target frame, clamped to stay on screen.
# a window larger than the target display pins to the top left and overflows;
# nothing here resizes it.
read -r x y <<EOF
$(jq -rn --argjson w "$win" --argjson d "$displays" --argjson c "$cur" --argjson t "$target" '
	($d[] | select(.index == $c) | .frame) as $src |
	($d[] | select(.index == $t) | .frame) as $dst |
	$w.frame as $f |
	((($f.x - $src.x) / $src.w * $dst.w) + $dst.x) as $x |
	((($f.y - $src.y) / $src.h * $dst.h) + $dst.y) as $y |
	"\([$dst.x, ([$x, $dst.x + $dst.w - $f.w] | min)] | max | floor) \([$dst.y, ([$y, $dst.y + $dst.h - $f.h] | min)] | max | floor)"
')
EOF

# the move must stay immediate: left alone, macOS drifts the window to a
# position of its own about a second after the space change. setting the frame
# here preempts that, and the value then sticks.
yabai -m window "$id" --space "$space"
yabai -m window "$id" --move abs:"$x":"$y"
yabai -m window "$id" --focus
