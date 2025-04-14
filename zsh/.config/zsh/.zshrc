# general -->
export EDITOR="nvim"
export VISUAL="nvim"
export MANPAGER='nvim +Man!'            # open manpages with vim
export MANWIDTH=999

setopt autocd                           # no need to use cd to cd into directory
autoload -U colors && colors            # enable colors
# <--

# history --> 
HISTFILE="$XDG_CACHE_HOME/zsh/history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt inc_append_history               # append to history file without having to exit shell

# use existing string to search history
autoload -Uz up-line-or-beginning-search 
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey -M viins "^[[A" up-line-or-beginning-search
bindkey -M viins "^[[B" down-line-or-beginning-search
# <--

# aliases -->
# list alias:
# - show hidden files (-A),
# - add slashes after directories (-F)
# - delete total count (sed '1d')
# - don't show .DS_Store (sed '.DS_Store'/d)
# - don't show file permissions (rest of sed command)
alias ll"=ls -ohAF --color=always | sed '1d;/.DS_Store/d;s/^.\{11\}[[:space:]]*[[:digit:]]*[[:space:]]//g'"

# make things safe and verbose
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Ivr"
mkd() {
	mkdir -pv -- "$1" && cd -- "$1"
}

alias vim=nvim
alias python=python3

# parent directories
alias ...=../..
alias ....=../../..
alias .....=../../../..
# <--

# autocompletion -->
autoload -U compinit
zstyle ':completion:*' menu select         # enable tab selection
zmodload zsh/complist
compinit -d $XDG_CACHE_HOME/zsh/zcompdump  # create cache file in appropriate location
_comp_options+=(globdots)                  # autocomplete hidden files
# <--

# prompt -->
fpath+=($ZDOTDIR/prompts/pure)             # add prompts/pure to fpath
export PURE_PROMPT_SYMBOL='>'
export PURE_PROMPT_VICMD_SYMBOL='<'
export PURE_GIT_UP_ARROW='↑'
export PURE_GIT_DOWN_ARROW='↓'
autoload -U promptinit; promptinit         # initialize prompt selector widget
prompt pure                                # select pure

# print newline after command but not first line
new-line() {
	if [ -z "$NEW_LINE_BEFORE_PROMPT" ]; then
		NEW_LINE_BEFORE_PROMPT=1
	elif [ "$NEW_LINE_BEFORE_PROMPT" -eq 1 ]; then
		echo ""
	fi
}
autoload -Uz add-zsh-hook
add-zsh-hook precmd new-line

alias clear="unset NEW_LINE_BEFORE_PROMPT && clear" # redefine clear so that it does not add newline
# <--

# vim mode -->
bindkey -v              # enable vi mode
export KEYTIMEOUT=1     # do not wait to enter vi mode

# bindkey "^H" backward-delete-char
bindkey "^?" backward-delete-char
bindkey -M viins "^[[3~" delete-char

# change cursor shape for different vi modes.
beam-cursor() { echo -ne '\e[5 q' }
block-cursor() { echo -ne '\e[1 q' }
function switch-cursor () {
	case $KEYMAP in
		vicmd) block-cursor;;             # block cursor in normal mode
		viins|main) beam-cursor;;         # beam cursor in command mode
	esac
}
zle -N switch-cursor
zle -N beam-cursor
add-zle-hook-widget zle-keymap-select switch-cursor  # switch cursor whenever modes are switched
add-zle-hook-widget zle-line-init beam-cursor        # use beam cursor whenever a line is initialized
# add-zsh-hook preexec beam-cursor

# use existing string to search history also in vi mode
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search
# <--

# misc -->
# clear half the screen
zz() {
	for i in {1..$((LINES/2))}
	do
		echo
	done
	tput cup $((LINES/2 - 4)) 0
}
# <--
