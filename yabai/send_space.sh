#!/usr/bin/env sh
. "$HOME/.config/yabai/lib.sh"
# send the focused space to the other display and follow it there.

displays=$(yabai -m query --displays)
[ "$(printf '%s' "$displays" | jq 'length')" -lt 2 ] && exit 0

cur=$(yabai_focused_index "$displays")
target=$(yabai_other_index "$displays" "$cur")

# yabai refuses to move a display's last space, so leave a fresh one behind
[ "$(yabai -m query --spaces --display "$cur" | jq 'length')" -eq 1 ] && yabai -m space --create

# --create and --display both renumber spaces; track the space by uuid
uuid=$(yabai -m query --spaces --space | jq -r '.uuid')
yabai -m space --display "$target" || exit 1

idx=$(yabai -m query --spaces | jq -r --arg u "$uuid" '.[] | select(.uuid==$u) | .index')
yabai -m space --focus "$idx"
