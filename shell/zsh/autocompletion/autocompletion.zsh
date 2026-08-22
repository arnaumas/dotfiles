# suggest only when the completion is unique
_zsh_autosuggest_capture_postcompletion() {
	(( compstate[nmatches] == 1 )) && compstate[insert]=1 || unset 'compstate[insert]'
	unset 'compstate[list]'
}

# an untouched buffer means nothing was inserted
_zsh_autosuggest_strategy_unique_completion() {
	_zsh_autosuggest_strategy_completion "$@"
	[[ "$suggestion" == "$1" ]] && unset suggestion
}

# keep the live suggestion visible to the Tab guard
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(tab-accept-or-complete)
typeset -ga FZF_DEEP_CMDS=(vim nvim vi cd)

# <Tab> accepts the suggestion if shown, else fzf-tab / fzf-completion
tab-accept-or-complete() {
	if [[ -n "$POSTDISPLAY" ]]; then
		zle autosuggest-accept
		zle redisplay
		return
	fi

	local words=(${(z)LBUFFER}) cmd
	cmd=$words[1]

	if (( ${#words} <= 1 )) && [[ ${LBUFFER[-1]} != ' ' ]]; then
		zle fzf-tab-complete; return
	fi

	if (( ${FZF_DEEP_CMDS[(Ie)$cmd]} )) || [[ -z $_comps[$cmd] || $_comps[$cmd] == _default ]]; then
		zle fzf-completion
	else
		zle fzf-tab-complete
	fi
}
zle -N tab-accept-or-complete
bindkey -M viins '^I' tab-accept-or-complete
