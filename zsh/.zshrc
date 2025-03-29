export ZSH=$HOME/.oh-my-zsh

plugins=(git)

source $ZSH/oh-my-zsh.sh

# Set theme to pure
ZSH_THEME=""

fpath+=($HOME/.zsh/pure)
autoload -U promptinit; promptinit
prompt pure
# Comment out the print in prompt_pure_preprompt_render in pure.zsh to remove initial newline

alias vim="nvim"
alias python="python3"

alias ll='ls -oA'

source <(fzf --zsh)

# open manpages with vim
export MANPAGER='nvim +Man!'
export MANWIDTH=999

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.
PURE_PROMPT_SYMBOL=">"
PURE_PROMPT_VICMD_SYMBOL="<"

clear
