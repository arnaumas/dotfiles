# general settings and toggles ===============================
export EDITOR="nvim"
export MANPAGER='nvim +Man!'
export MANWIDTH=999

setopt autocd                           # no need to use cd to cd into directory
autoload -U colors && colors            # enable colors


# history ===============================
HISTFILE="$XDG_CACHE_HOME/zsh/history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt inc_append_history               # append to history file without having to exit shell

# use existing string to search history
autoload -Uz up-line-or-beginning-search 
autoload -Uz down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey "^[[A" up-line-or-beginning-search
bindkey "^[[B" down-line-or-beginning-search

# aliases and bookmarks
alias -g vim=nvim

# make things safe and verbose
alias cp="cp -iv"
alias mv="mv -iv"
alias rm="rm -Ivr"
mkd() {
	mkdir -pv -- "$1" &&
		cd -- "$1"
	}

# autocompletion ====================================
autoload -U compinit
zstyle ':completion:*' menu select         # enable tab selection
zmodload zsh/complist
compinit -d $XDG_CACHE_HOME/zsh/zcompdump  # create cache file in appropriate location
_comp_options+=(globdots)                  # autocomplete hidden files


# prompt =========================================
fpath+=($ZDOTDIR/prompts/pure)             # add prompts/pure to fpath
export PURE_PROMPT_SYMBOL='>'
export PURE_PROMPT_VICMD_SYMBOL='<'
export PURE_GIT_UP_ARROW='↑'
export PURE_GIT_DOWN_ARROW='↓'
autoload -U promptinit; promptinit         # initialize prompt selector widget
prompt pure                                # select pure


alias clear="unset NEW_LINE_BEFORE_PROMPT && clear" # redefine clear so that it does not add newline


# list alias:
# - show hidden files (-A),
# - add slashes after directories (-F)
# - delete total count (sed '1d')
# - don't show .DS_Store (sed '.DS_Store'/d)
# - don't show file permissions (rest of sed command)
alias ll"=ls -ohAF --color=always | sed '1d;/.DS_Store/d;s/^.\{11\}[[:space:]]*[[:digit:]]*[[:space:]]//g'"

# misc ==========================================
zz() {
	for i in {1..$((LINES/2))}
	do
		echo
	done
	tput cup $((LINES/2 - 4)) 0
}




# OLD STUFF ==========================================

# alias -g vim="nvim"
# alias python="python3"
#
#
# source <(fzf --zsh)
#
# # open manpages with vim
#
# # vi mode
# bindkey -v
# export KEYTIMEOUT=1
#
# # Change cursor shape for different vi modes.
# function zle-keymap-select {
#   if [[ ${KEYMAP} == vicmd ]] ||
#      [[ $1 = 'block' ]]; then
#     echo -ne '\e[1 q'
#   elif [[ ${KEYMAP} == main ]] ||
#        [[ ${KEYMAP} == viins ]] ||
#        [[ ${KEYMAP} = '' ]] ||
#        [[ $1 = 'beam' ]]; then
#     echo -ne '\e[5 q'
#   fi
# }
# zle -N zle-keymap-select
# zle-line-init() {
#     zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
#     echo -ne "\e[5 q"
# }
# zle -N zle-line-init
# echo -ne '\e[5 q' # Use beam shape cursor on startup.
# preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
#
