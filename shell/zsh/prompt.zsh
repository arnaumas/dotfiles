autoload -Uz add-zsh-hook add-zle-hook-widget vcs_info
zmodload zsh/datetime 2>/dev/null

setopt prompt_subst
export PROMPT_EOL_MARK=''
export VIRTUAL_ENV_DISABLE_PROMPT=1

# symbols, overridable from the environment
: ${PURE_PROMPT_SYMBOL:=>}
: ${PURE_PROMPT_VICMD_SYMBOL:=<}
: ${PURE_GIT_DOWN_ARROW:=↓}
: ${PURE_GIT_UP_ARROW:=↑}

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' check-for-changes false
zstyle ':vcs_info:git*' formats '%b'
zstyle ':vcs_info:git*' actionformats '%b' '%a'

typeset -g _p_symbol=$PURE_PROMPT_SYMBOL
typeset -g _p_last_exit=0
typeset -gA _p_fetch_at

# '*' if the working tree is dirty, empty otherwise
_p_git_dirty() {
	command git rev-parse --is-inside-work-tree &>/dev/null || return
	[[ -n $(command git status --porcelain --ignore-submodules -unormal 2>/dev/null) ]] \
		&& print -r -- '*'
}

# ↓/↑ arrows from local refs (no fetch here; the async job refreshes the refs)
_p_git_arrows() {
	local lr left right a
	lr=$(command git rev-list --left-right --count HEAD...@{u} 2>/dev/null) || return
	left=${lr%%[[:space:]]*}
	right=${lr##*[[:space:]]}
	(( right > 0 )) && a+=$PURE_GIT_DOWN_ARROW
	(( left > 0 )) && a+=$PURE_GIT_UP_ARROW
	[[ -n $a ]] && print -r -- "$a"
}

# process that have been put in the background
_p_suspended() {
	local -a susp
	local j
	for j in ${(k)jobstates}; do
		[[ ${jobstates[$j]} == suspended* ]] && susp+=${jobtexts[$j]%% *}
	done
	(( $#susp )) || return
	local extra=''
	(( $#susp > 1 )) && extra=" +$(( $#susp - 1 ))"
	print -r -- "(${susp[1]}${extra})"
}

_p_render() {
	vcs_info

	local -a parts

	# suspended background jobs
	local susp=$(_p_suspended)
	[[ -n $susp ]] && parts+="%F{yellow}${susp}%f"

	# user@host, only over ssh
	[[ -n $SSH_CONNECTION ]] && parts+='%F{7}%n@%m%f'

	# exit code (red) then path
	local path_seg='%F{blue}%~%f'
	(( _p_last_exit )) && path_seg="%F{red}[${_p_last_exit}]%f ${path_seg}"
	parts+=$path_seg

	# git: on <branch><dirty> <action> <arrows>
	if [[ -n $vcs_info_msg_0_ ]]; then
		local dirty=$(_p_git_dirty)
		parts+="%F{default}on ${vcs_info_msg_0_}%F{yellow}${dirty}%f"
		[[ -n $vcs_info_msg_1_ ]] && parts+="%F{yellow}${vcs_info_msg_1_}%f"
		local arrows=$(_p_git_arrows)
		[[ -n $arrows ]] && parts+="%F{cyan}${arrows}%f"
	fi

	local preprompt=${(j: :)parts}

	# line 2: venv (grey) + always-blue vi-aware symbol. The symbol is left as a
	# live ${_p_symbol} reference so keymap changes only need `zle reset-prompt`.
	local venv=''
	[[ -n $VIRTUAL_ENV ]] && venv="%F{7}${VIRTUAL_ENV:t}%f "
	PROMPT="${preprompt}"$'\n'"${venv}"'%F{blue}${_p_symbol}%f '
	PROMPT2='%F{blue}${_p_symbol}%f '
}

# async git fetch
_p_fetch_job() {
	builtin cd -q "$1" 2>/dev/null || return
	command git rev-parse '@{u}' &>/dev/null || return   # needs an upstream
	command git -c gc.auto=0 fetch --quiet --no-tags --recurse-submodules=no 2>/dev/null
}

_p_maybe_fetch() {
	(( _p_async )) || return
	command git rev-parse --is-inside-work-tree &>/dev/null || return
	local top
	top=$(command git rev-parse --show-toplevel 2>/dev/null) || return
	[[ $top == $HOME ]] && return                         # skip $HOME
	local now=$EPOCHSECONDS
	(( now - ${_p_fetch_at[$top]:-0} < 60 )) && return    # at most once a minute
	_p_fetch_at[$top]=$now
	async_job _p_worker _p_fetch_job "$PWD"
}

_p_async_callback() {
	[[ $1 == '[async]' ]] && return                       # worker bookkeeping
	_p_render                                             # fetch done: refresh arrows
	zle && zle reset-prompt
}

if async_start_worker _p_worker -n 2>/dev/null; then
	async_register_callback _p_worker _p_async_callback
	typeset -g _p_async=1
fi

# --- hooks -----------------------------------------------------------------
_p_precmd() {
	_p_last_exit=$?          # must stay first: capture the real command status
	_p_render
	_p_maybe_fetch
}
add-zsh-hook precmd _p_precmd

# swap >/< on vi-mode change and redraw in place
_p_keymap() {
	case $KEYMAP in
		vicmd) _p_symbol=$PURE_PROMPT_VICMD_SYMBOL ;;
		*)     _p_symbol=$PURE_PROMPT_SYMBOL ;;
	esac
	zle reset-prompt
}
zle -N _p_keymap
add-zle-hook-widget zle-keymap-select _p_keymap
add-zle-hook-widget zle-line-init _p_keymap
