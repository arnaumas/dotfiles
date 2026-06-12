# Read for every zsh invocation (login, interactive, and scripts), and always
# before .zprofile/.zshrc. ZDOTDIR must be set here so that non-login shells can
# still find ~/.config/zsh/.zshrc.

# move configuration files to ~/.config
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
export CLAUDE_CONFIG_DIR="$XDG_CONFIG_HOME/claude"
