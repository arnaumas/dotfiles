# NOTE: XDG_* and ZDOTDIR are set in ~/.zshenv so they apply to non-login
# shells too (this file is only sourced for login shells).

# PATH exports
# homebrew binaries
export PATH=$PATH:/opt/homebrew/bin
# needed for claude code
export PATH=$PATH:$HOME/.local/bin
# obsidian
export PATH=$PATH:/Applications/Obsidian.app/Contents/MacOS

# disable shell sesions
export SHELL_SESSIONS_DISABLE=1

