rg-widget() {
	# rg to use
	local rg_prefix='rg --line-number --no-heading --color=always --smart-case'
	local out
	# fzf settings
	out=$(
		FZF_DEFAULT_COMMAND= \
		fzf --ansi --disabled --multi --height=80% \
			--delimiter : \
			--bind "change:reload:sleep 0.05; ${rg_prefix} -- {q} || true" \
	) || { zle reset-prompt; return }

	[[ -z $out ]] && { zle reset-prompt; return }

	# parse the matches into editor args
	local -a args
	local line file ln first=1
	while IFS= read -r line; do
		file=${line%%:*}
		ln=${${line#*:}%%:*}
		if (( first )); then
			args=(+$ln -- $file); first=0
		else
			args+=(-c "edit +$ln ${(q)file}")
		fi
	done <<< "$out"
	(( ! first )) && args+=(-c 'buffer 1')

	# open the matches
	${EDITOR:-nvim} "${args[@]}" </dev/tty
	zle reset-prompt
}
zle -N rg-widget
bindkey '^g' rg-widget
