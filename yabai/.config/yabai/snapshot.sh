#!/usr/bin/env sh
. "$HOME/.config/yabai/lib.sh"
# record space uuids per display; on_display_added.sh restores the external's

FILE="$CACHE/layout.json"

displays=$(yabai -m query --displays)
# with <2 displays the external is gone; writing would clobber the snapshot
[ "$(printf '%s' "$displays" | jq 'length')" -lt 2 ] && exit 0

main=$(yabai_main_index "$displays")
case "$main" in ''|null) exit 0 ;; esac
ext=$(yabai_other_index "$displays" "$main")
case "$ext" in ''|null) exit 0 ;; esac

# scratchpads sit in a space's window list but belong to no space
keep=$(yabai -m query --windows | jq -c '[.[] | select(.scratchpad == "") | .id]')
layout=$(yabai -m query --spaces | jq -c --argjson keep "$keep" \
	--argjson main "$main" --argjson ext "$ext" '{
		ext: [.[] | select(.display == $ext)
			| {uuid, windows: [.windows[] | select(IN($keep[]))]}],
		main: [.[] | select(.display == $main) | .uuid]
	}')

mkdir -p "$CACHE"
printf '%s\n' "$layout" > "$FILE"
