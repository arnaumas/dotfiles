#!/bin/zsh

# Symlink configuration files
ln -s "$HOME/dotfiles/nvim/init.vim" "$HOME/.config/nvim/init.vim"

mkdir -p "$HOME/.config/nvim/lua"
ln -s "$HOME/dotfiles/nvim/lua/packer.lua" "$HOME/.config/nvim/lua/packer.lua"
