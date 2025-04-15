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

# move history files to appropriate locations to appropriate location
export PYTHON_HISTORY="$XDG_CACHE_HOME/python/history"
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"

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
beam-cursor() { echo -ne '\e[6 q' }
block-cursor() { echo -ne '\e[2 q' }
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
add-zsh-hook preexec beam-cursor

# use existing string to search history also in vi mode
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

# edit line in vim with ctrl-e:
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[3~' vi-delete-char
bindkey -M visual '^[[3~' vi-delete
bindkey -M vicmd '^e' edit-command-line
# <--

# plugins -->
function zsh-add-plugin() {
	PLUGIN_NAME=$(echo $1 | cut -d "/" -f 2)
	if [ -d "$ZDOTDIR/plugins/$PLUGIN_NAME" ]; then 
		# For plugins
		source "$ZDOTDIR/plugins/$PLUGIN_NAME/$PLUGIN_NAME.plugin.zsh" || \
			source "$ZDOTDIR/plugins/$PLUGIN_NAME/$PLUGIN_NAME.zsh"
	else
		git clone "https://github.com/$1.git" "$ZDOTDIR/plugins/$PLUGIN_NAME"
	fi
}

zsh-add-plugin "zdharma-continuum/fast-syntax-highlighting"
# <--

# misc -->
# clear half the screen
#
# TODO: Fix this
clear-half() {
	CURSOR_PREV="$CURSOR"
	HALFLINES=$(( (LINES-1)/2 ))
	for i in {1..$HALFLINES}; do echo; done
	if [[ $? -eq 0 ]]; then
		tput cup $(( HALFLINES )) $((CURSOR_PREV + 2))
	else
		tput cup $(( LINES - HALFLINES )) $((CURSOR_PREV + 3 + $#?))
	fi
}
zle -N clear-half
bindkey -M vicmd "zz" clear-half
# <--
