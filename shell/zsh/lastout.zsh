# track the previous command's output rows, for the L pager function.
# tmux has no command boundaries, so record them with preexec/precmd.
autoload -Uz add-zsh-hook

typeset -g _L_cur_start _L_last_start _L_last_end

# before the command runs: remember where its output will start
_L_preexec() {
	[[ -n $TMUX ]] || return
	local hs cy
	read hs cy <<<"$(tmux display -p '#{history_size} #{cursor_y}')"
	_L_cur_start=$(( hs + cy ))
}

# after it finishes: commit the range as the last command's output
_L_precmd() {
	[[ -n $TMUX && -n $_L_cur_start ]] || return
	local hs cy
	read hs cy <<<"$(tmux display -p '#{history_size} #{cursor_y}')"
	_L_last_start=$_L_cur_start
	_L_last_end=$(( hs + cy - 1 ))
	_L_cur_start=
}

add-zsh-hook preexec _L_preexec
add-zsh-hook precmd _L_precmd

# page the previous command's output, keeping its colors (-e)
L() {
	[[ -n $TMUX && -n $_L_last_start ]] || { echo "no captured output"; return 1; }
	local hs=$(tmux display -p '#{history_size}')
	tmux capture-pane -pe -S $(( _L_last_start - hs )) -E $(( _L_last_end - hs )) | less -+F -+X
}
