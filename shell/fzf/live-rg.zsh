live-rg() {
	# rg to use
	local rg_prefix='rg --line-number --no-heading --color=always --smart-case'
	local out
	# fzf settings
	out=$(
		FZF_DEFAULT_COMMAND= \
		fzf --ansi --disabled --multi \
			--delimiter : \
			--prompt 'rg > ' \
			--bind "change:reload:sleep 0.05; ${rg_prefix} -- {q} || true" \
			--height=30
	)

	# nothing picked
	[[ -z $out ]] && return

	# parse the matches into editor args
	local -a args
	local line file ln
	while IFS= read -r line; do
		file=${line%%:*}
		ln=${${line#*:}%%:*}
		args+=(-c "edit +$ln ${(q)file}")
	done <<< "$out"
	args+=(-c 'buffer 1')

	# open the matches
	BUFFER="${EDITOR:-nvim} ${(j: :)${(@q)args}}"
	zle accept-line
}

live-rg-widget() { live-rg; zle reset-prompt }
zle -N live-rg-widget
bindkey '^g' live-rg-widget
