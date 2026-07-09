#!/usr/bin/env bash

CONFIG="$HOME/.config/sketchybar"
source "$CONFIG/style.sh"

spaces=$(yabai -m query --spaces)
windows=$(yabai -m query --windows)
bar=$(sketchybar --query bar)
existing=$(jq -c '[.items[] | select(startswith("space."))]' <<<"$bar")

# app name (yabai .app) -> nerd font glyph; default 󰣆
icons='{
	"Safari":"󰖟","Helium":"󰖟","Google Chrome":"󰖟","Firefox":"󰖟",
	"Mail":"󰇮",
	"Calendar":"󰃭",
	"WhatsApp":"󰖣",
	"Ghostty":"","Terminal":"","iTerm2":"","kitty":"","Alacritty":"",
	"sioyek":"󰈦","Preview":"󰈦","Skim":"󰈦",
	"JabRef":"󱉟",
	"Obsidian":"󰠮",
	"Claude":"󰚩",
	"Numbers":"󰄨",
	"Music":"󰎈","Música":"󰎈","Spotify":"󰎈",
	"Finder":"󰀶",
	"Calculator":"󰪚",
	"System Settings":"󰒓","Configuració del Sistema":"󰒓"
}'

args=()
while IFS= read -r -d '' a; do args+=("$a"); done < <(
	jq -nj \
		--argjson spaces  "$spaces" \
		--argjson windows "$windows" \
		--argjson existing "$existing" \
		--argjson icons   "$icons" \
		--arg hl  "$HL_BG" \
		--arg cfg "$CONFIG" '
		# glyphs per space index (only real standard windows, not phantom bg ones)
		( [ $windows[] | select(.subrole == "AXStandardWindow") ]
			| group_by(.space)
			| map({ (.[0].space|tostring):
				(map(.app) | unique | map($icons[.] // "󰣆")) })
			| add // {} ) as $byspace
		| [ $spaces[].index | "space.\(.)" ] as $desired
		| ( [ $spaces[]
				| .index as $i
				| "space.\($i)" as $name
				| (.label // "") as $lbl
				| (($byspace[$i|tostring] // []) | join(" ")) as $g
				| ((if $lbl == "" then ($i|tostring) else $lbl end)
						+ (if $g == "" then "" else " " + $g end)) as $text
				| (
						if ($existing | index($name)) then empty
						else "--add","item",$name,"left",
							"--set",$name,"icon.drawing=off",
								"label.padding_left=8","label.padding_right=8",
								"script=\($cfg)/plugins/hover.sh",
								"click_script=yabai -m space --focus \($i)",
							"--subscribe",$name,"mouse.entered","mouse.exited"
						end
					),
					"--set",$name,"label=\($text)",
					"padding_left=\(if .index ==$spaces[0].index then 4 else 1 end)",
					"padding_right=\(if .index ==$spaces[-1].index then 4 else 1 end)",
					( if .["has-focus"]
						then "background.drawing=on","background.color=\($hl)"
						else "background.drawing=off" end )
			]
			+ [ ($existing - $desired)[] | ("--remove", .) ]
			)
		| .[] + "\u0000"
	'
)
[ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"

# rebuild the bracket only when membership changes (avoids flicker)
desired=$(jq -r '[.[].index | "space.\(.)"] | join(" ")' <<<"$spaces")
state="${TMPDIR:-/tmp}/sketchybar_spaces_members"
old=$(cat "$state" 2>/dev/null || true)
if [ "$desired" != "$old" ] || ! jq -e '.items | index("spaces")' <<<"$bar" >/dev/null; then
	sketchybar --remove spaces 2>/dev/null
	if [ -n "$desired" ]; then
		# shellcheck disable=SC2086
		sketchybar --add bracket spaces $desired --set spaces "${bracket[@]}"
	fi
	printf '%s' "$desired" >"$state"
fi
