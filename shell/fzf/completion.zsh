# fzf provider: fzf-tab for known completers, fzf-completion for deep/unknown
COMPLETION_PROVIDER=fzf-dispatch
typeset -ga FZF_DEEP_CMDS=(vim nvim vi cd)

fzf-dispatch() {
	local words=(${(z)LBUFFER}) cmd
	cmd=$words[1]

	if (( ${#words} <= 1 )) && [[ ${LBUFFER[-1]} != ' ' ]]; then
		zle fzf-tab-complete; return
	fi

	if (( ${FZF_DEEP_CMDS[(Ie)$cmd]} )) || [[ -z $_comps[$cmd] || $_comps[$cmd] == _default ]]; then
		zle fzf-completion
		[[ $LBUFFER == *'\~'* ]] && LBUFFER=${LBUFFER//'\~'/'~'}
	else
		zle fzf-tab-complete
	fi
}
zle -N fzf-dispatch

# fzf-tab: the completion menu
zstyle ':fzf-tab:*' switch-group '^' '+'
zstyle ':fzf-tab:*' continuous-trigger '/'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls -p --color=always -- "$realpath" 2>/dev/null'
zstyle ':fzf-tab:complete:*:*' fzf-preview \
	'[[ -d "$realpath" ]] && ls -p --color=always -- "$realpath" 2>/dev/null || bat --color=always --style=plain --theme=ansi16 -- "$realpath" 2>/dev/null || true'

# fzf-completion: fd-backed deep completion
export FZF_COMPLETION_TRIGGER=
export FZF_COMPLETION_OPTS='--ansi --height=20'
_fzf_compgen_path() {
	if [[ $1 == . ]]; then
		fd --strip-cwd-prefix --hidden --follow --color=always --exclude .git
	else
		fd --hidden --follow --color=always --exclude .git . "$1" | sed "s|$HOME|~|"
	fi
}
_fzf_compgen_dir() {
	if [[ $1 == . ]]; then
		fd --type d --max-depth 5 --strip-cwd-prefix --hidden --follow --color=always --exclude .git
	else
		fd --type d --max-depth 5 --hidden --follow --color=always --exclude .git . "$1" | sed "s|$HOME|~|"

	fi
}
_fzf_comprun() {
	local command=$1; shift
	case "$command" in
		cd) fzf --height=20 --exit-0 --preview 'p={}; ls -p --color=always -- "${p/#\~/$HOME}" 2>/dev/null' "$@" ;;
		*)  fzf --height=20 --exit-0 --preview 'p={}; [[ -d "${p/#\~/$HOME}" ]] && ls -p --color=always -- "${p/#\~/$HOME}" 2>/dev/null \
			|| bat --color=always --style=plain -- "${p/#\~/$HOME}" 2>/dev/null || true' "$@" ;;
	esac
}
