# -- autosuggest: only ever suggest a unique completion
# a single match means we can safely insert it
_zsh_autosuggest_capture_postcompletion() {
	(( compstate[nmatches] == 1 )) && compstate[insert]=1 || unset 'compstate[insert]'
	unset 'compstate[list]'
}

# an untouched buffer means nothing was inserted
_zsh_autosuggest_strategy_unique_completion() {
	_zsh_autosuggest_strategy_completion "$@"
	[[ "$suggestion" == "$1" ]] && unset suggestion
}

# <Tab>: accept suggestion if shown, else the completion provider, else native
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(tab-accept-or-complete)

tab-accept-or-complete() {
	if [[ -n "$POSTDISPLAY" ]]; then
		zle autosuggest-accept
		region_highlight=( ${(M)region_highlight:#*memo=*} )
		zle redisplay
		return
	fi

	# COMPLETION_PROVIDER is a widget name claimed by whatever provider is loaded
	if [[ -n "$COMPLETION_PROVIDER" ]] && (( $+widgets[$COMPLETION_PROVIDER] )); then
		zle "$COMPLETION_PROVIDER"
	else
		zle expand-or-complete
	fi
}
zle -N tab-accept-or-complete
bindkey -M viins '^I' tab-accept-or-complete

# zsh completion matching + colors
# tried in order, each only if the previous found nothing; fuzzy last
zstyle ':completion:*' matcher-list \
	'' \
	'm:{a-z}={A-Z}' \
	'r:|[._-]=* r:|=*' \
	'r:|?=**'

# candidate colors: dir=blue, symlink=magenta (files stay default)
zstyle ':completion:*' list-colors \
	'di=34' 'ln=35' 'so=32' 'pi=33' 'ex=31' \
	'bd=34;46' 'cd=34;43' 'su=30;41' 'sg=30;46' 'tw=30;42' 'ow=30;43'

zstyle ':completion:*' special-dirs false
