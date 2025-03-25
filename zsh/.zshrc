export ZSH=$HOME/.oh-my-zsh

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Set theme to pure
ZSH_THEME=""

fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure
# Comment out the print in prompt_pure_preprompt_render in pure.zsh to remove initial newline

PURE_PROMPT_SYMBOL=">"
PURE_PROMPT_VICMD_SYMBOL="<"

alias vim="nvim"

alias ll='ls -oA'

source <(fzf --zsh)

# open manpages with vim
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# # change cursor based on mode
bindkey -v
KEYTIMEOUT=5
# # Change cursor shape for different vi modes.
# function zle-keymap-select {
# if [[ ${KEYMAP} == vicmd ]] ||
# 	[[ $1 = 'block' ]]; then
# 	echo -ne '\e[1 q'
#
# elif [[ ${KEYMAP} == main ]] ||
# 	[[ ${KEYMAP} == viins ]] ||
# 	[[ ${KEYMAP} = '' ]] ||
# 	[[ $1 = 'beam' ]]; then
# 	echo -ne '\e[5 q'
# fi
# }
# zle -N zle-keymap-select
#
# # Use beam shape cursor on startup.
# echo -ne '\e[5 q'
# # Use beam shape cursor for each new prompt.
# preexec() {
# 	echo -ne '\e[5 q'
# }

clear
