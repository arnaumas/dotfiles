export KEYTIMEOUT=1

bindkey "^?" backward-delete-char
bindkey -M viins "^[[3~" delete-char

beam-cursor() { echo -ne '\e[6 q' }
block-cursor() { echo -ne '\e[2 q' }
function switch-cursor () {
	case $KEYMAP in
		vicmd|viopp|visual) block-cursor;;
		viins|main) beam-cursor;;
	esac
}
zle -N switch-cursor
zle -N beam-cursor
add-zle-hook-widget zle-line-pre-redraw switch-cursor
add-zle-hook-widget zle-line-init beam-cursor
add-zsh-hook preexec beam-cursor

bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

autoload edit-command-line
_edit-command-line() {
	local -x ZLE_NAMES="${(k)aliases} ${(k)functions:#_*}"
	edit-command-line
}
zle -N edit-command-line _edit-command-line
bindkey '^e' edit-command-line
bindkey -M vicmd '^[[3~' vi-delete-char
bindkey -M visual '^[[3~' vi-delete
bindkey -M vicmd '^e' edit-command-line
