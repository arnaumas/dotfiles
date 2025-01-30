#!/bin/zsh

# Symlink configuration files
ln -s "$HOME/dotfiles/nvim/init.lua" "$HOME/.config/nvim/init.lua"

mkdir -p "$HOME/.config/nvim/lua"
ln -s "$HOME/dotfiles/nvim/lua/packer.lua" "$HOME/.config/nvim/lua/packer.lua"
