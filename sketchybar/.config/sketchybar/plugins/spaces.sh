#!/usr/bin/env bash

CONFIG="$HOME/.config/sketchybar"
source "$CONFIG/style.sh"

# Serialized: a run that finds the lock taken leaves a marker and exits, and the holder
# re-runs for it. Otherwise a slow copy (1.5s+ during a display teardown, against 70ms
# idle) finishes last and overwrites a newer render with its stale snapshot.
LOCK="${TMPDIR:-/tmp}/sketchybar_spaces.lock"
PENDING="${TMPDIR:-/tmp}/sketchybar_spaces.pending"

: >"$PENDING"
if ! mkdir "$LOCK" 2>/dev/null; then
	# reclaim a lock orphaned by a killed run
	if [ -n "$(find "$LOCK" -maxdepth 0 -mmin +1 2>/dev/null)" ]; then
		rmdir "$LOCK" 2>/dev/null
		mkdir "$LOCK" 2>/dev/null || exit 0
	else
		exit 0
	fi
fi
trap 'rmdir "$LOCK" 2>/dev/null' EXIT INT TERM

# clear before querying yabai: anything arriving from here on must force another pass
rm -f "$PENDING"

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
	"Ghostty":"","Terminal":"","iTerm2":"","kitty":"","Alacritty":"",
	"sioyek":"","Preview":"","Skim":"",
	"JabRef":"󱉟",
	"Obsidian":"󰠮",
	"Claude":"󰚩",
	"Numbers":"󰄨",
	"Music":"󰎈","Música":"󰎈","Spotify":"󰎈",
	"Finder":"󰀶",
	"Calculator":"󰪚",
	"System Settings":"󰒓","Configuració del Sistema":"󰒓"
}'

# desired item list, in display order: a "|" separator before the first space of each new
# display. Drives the adds, removals, --reorder and the bracket.
# Within a display: unlabelled spaces first, then labelled, each by index. Display stays
# the primary key so the groups remain contiguous for the separator walk.
desired_json=$(jq -c '
	sort_by(.display, ((.label // "") != ""), .index) as $sp
	| [ range(0; $sp|length) as $k
			| (if $k > 0 and $sp[$k].display != $sp[$k-1].display
				then ["space.sep.\($sp[$k].display)"] else [] end)
				+ ["space.\($sp[$k].index)"] ]
	| add // []' <<<"$spaces")

args=()
while IFS= read -r -d '' a; do args+=("$a"); done < <(
	jq -nj \
		--argjson spaces  "$spaces" \
		--argjson windows "$windows" \
		--argjson existing "$existing" \
		--argjson desired "$desired_json" \
		--argjson icons   "$icons" \
		--arg hl  "$HL_BG" \
		--arg bg  "$BG" \
		--arg dim "$DIM" \
		--arg cfg "$CONFIG" '
		# glyphs per space index (only real standard windows; skip sticky panels like browser PIP)
		( [ $windows[] | select(.subrole == "AXStandardWindow" and (."is-sticky" | not)
			and (.scratchpad == "" or .["is-visible"])) ]
			| group_by(.space)
			| map({ (.[0].space|tostring):
				(map(.app | gsub("\\p{Cf}"; "")) | sort | map($icons[.] // "󰣆")) })
			| add // {} ) as $byspace
		# desired_json order: the rounded end padding goes on the visually first/last item
		| ($spaces | sort_by(.display, ((.label // "") != ""), .index)) as $ord
		| ( [ $desired[]
				| select(startswith("space.sep.")) as $sep
				| select(($existing | index($sep)) | not)
				| "--add","item",$sep,"left",
					"--set",$sep,"icon.drawing=off",
						# icon.drawing=off still reserves the default icon padding (8 left / 1
						# right), which shoves the label right; zero it so the pipe centers
						"icon.padding_left=0","icon.padding_right=0",
						# sketchybar measures "|" as ~2pt but the font advances ~8pt, so the ink
						# lands right of the reserved box; the lopsided padding re-centers it
						"label=|","label.color=\($dim)",
						"label.padding_left=2","label.padding_right=8"
			]
			+ [ $spaces[]
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
					"padding_left=\(if .index == $ord[0].index then 4 else 1 end)",
					"padding_right=\(if .index == $ord[-1].index then 4 else 1 end)",
					( if .["has-focus"] then "background.drawing=on","background.color=\($hl)"
						elif .["is-visible"] then "background.drawing=on","background.color=\($bg)"
						else "background.drawing=off" end )
			]
			+ [ ($existing - $desired)[] | ("--remove", .) ]
			+ [ "--reorder" ] + $desired
			)
		| .[] + "\u0000"
	'
)
[ ${#args[@]} -gt 0 ] && sketchybar "${args[@]}"

# rebuild when the live bracket diverges from the desired list. Comparing against the
# bracket itself, not a cached file, self-heals: --add bracket silently drops names of
# items that do not exist yet.
desired=$(jq -r 'join(" ")' <<<"$desired_json")
current=$(sketchybar --query spaces 2>/dev/null \
	| jq -r '.bracket // [] | join(" ")' 2>/dev/null || true)
if [ "$desired" != "$current" ]; then
	sketchybar --remove spaces 2>/dev/null
	if [ -n "$desired" ]; then
		# shellcheck disable=SC2086
		sketchybar --add bracket spaces $desired --set spaces "${bracket[@]}"
	fi
fi

# requests that arrived while we rendered get a fresh pass, capped so an event storm
# cannot recurse without bound
if [ -e "$PENDING" ] && [ "${SP_DEPTH:-0}" -lt 5 ]; then
	export SP_DEPTH=$((${SP_DEPTH:-0} + 1))
	rmdir "$LOCK" 2>/dev/null
	trap - EXIT INT TERM
	exec "$0"
fi
