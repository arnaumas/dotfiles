# history settings
HISTFILE="${XDG_CACHE_HOME}/zsh/history"

# autocomplete
# - enable tab selection
# - autocomplete hidden files
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# colors
autoload -U colors && colors

# prompt
PS1="%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b "



# OLD STUFF ==========================================

# fpath+=($HOME/.zsh/pure)
# autoload -U promptinit; promptinit
# prompt pure
# # Comment out the print in prompt_pure_preprompt_render in pure.zsh to remove initial newline

alias vim="nvim"
alias python="python3"

# list alias:
# - show hidden files (-A),
# - add slashes after directories (-F)
# - delete total count (sed '1d')
# - don't show .DS_Store (sed '.DS_Store'd)
# - don't show file permissions (rest of sed command)
alias ll"=ls -ohAF --color=always | sed '1d;/.DS_Store/d;s/^.\{11\}[[:space:]]*[[:digit:]]*[[:space:]]//g'"

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

