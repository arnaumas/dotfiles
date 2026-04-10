# move configuration files to ~/.config
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# PATH exports
# homebrew binaries
export PATH=$PATH:/opt/homebrew/bin
# needed for claude code
export PATH=$PATH:$HOME/.local/bin
# obsidian
export PATH=$PATH:/Applications/Obsidian.app/Contents/MacOS

# disable shell sesions
export SHELL_SESSIONS_DISABLE=1

