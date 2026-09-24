_last_output() {
	local f=/tmp/wezterm-out-$WEZTERM_PANE
	[[ -s $f ]] || return
	less -+F -+X <$f >/dev/tty
	command rm -f $f
}
zle -N _last_output
bindkey '\e@seq@' _last_output
