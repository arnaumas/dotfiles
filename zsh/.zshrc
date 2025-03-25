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

bindkey -v

clear

alias vim="nvim"

alias ll='ls -oA'

source <(fzf --zsh)
