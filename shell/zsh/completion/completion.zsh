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

# -- <Tab>: accept the suggestion if shown, else route to fzf-tab / fzf-completion -->
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(tab-accept-or-complete)
typeset -ga FZF_DEEP_CMDS=(vim nvim vi cd)

tab-accept-or-complete() {
	if [[ -n "$POSTDISPLAY" ]]; then
		zle autosuggest-accept
		region_highlight=( ${(M)region_highlight:#*memo=*} )
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

# -- fzf-tab: the completion menu (known commands with a real completer)
zstyle ':fzf-tab:*' fzf-bindings 'tab:accept' 'enter:toggle+down'
zstyle ':fzf-tab:*' switch-group '^' '+'
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -p --color=always -- "$realpath" 2>/dev/null'
zstyle ':fzf-tab:complete:*:*' fzf-preview \
	'[[ -d "$realpath" ]] && ls -p --color=always -- "$realpath" 2>/dev/null || bat --color=always --style=plain --theme=ansi16 -- "$realpath" 2>/dev/null || true'

# -- fzf-completion: fd-backed deep completion (FZF_DEEP_CMDS + unknown cmds)
export FZF_COMPLETION_TRIGGER=
export FZF_COMPLETION_OPTS='--ansi --height=40%'
_fzf_compgen_path() { fd --strip-cwd-prefix --hidden --follow --color=always --exclude .git }
_fzf_compgen_dir()  { fd --strip-cwd-prefix --type d --hidden --follow --color=always --exclude .git }
_fzf_comprun() {
	local command=$1; shift
	case "$command" in
		cd) fzf --preview 'ls -p --color=always -- {} 2>/dev/null' "$@" ;;
		*)  fzf --preview '[[ -d {} ]] && ls -p --color=always -- {} 2>/dev/null || bat --color=always --style=plain -- {} 2>/dev/null || true' "$@" ;;
	esac
}

# -- zsh completion matching + colors (feeds the fzf-tab menu)
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
