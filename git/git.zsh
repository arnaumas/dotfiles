#!/bin/zsh

# Symlink git configuration files to home directory
ln -s "$HOME/dotfiles/git/gitconfig" "$HOME/.gitconfig"
ln -s "$HOME/dotfiles/git/gitignore_global" "$HOME/.gitignore_global"

