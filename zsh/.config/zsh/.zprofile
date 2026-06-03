# NOTE: XDG_* and ZDOTDIR are set in ~/.zshenv so they apply to non-login
# shells too (this file is only sourced for login shells).

# PATH exports
# homebrew: sets HOMEBREW_PREFIX, MANPATH, INFOPATH, fpath. Its path_helper call
# appends /opt/homebrew/{bin,sbin} after the system paths, so prepend them again
# below to make brew binaries take precedence (typeset -U dedupes the result).
eval "$(/opt/homebrew/bin/brew shellenv)"
path=("$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin" $path)
# needed for claude code
path+=("$HOME/.local/bin")
# obsidian
path+=("/Applications/Obsidian.app/Contents/MacOS")
typeset -U path

# disable shell sesions
export SHELL_SESSIONS_DISABLE=1

