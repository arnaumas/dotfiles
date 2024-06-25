#!/bin/zsh

# Symlink configuration files
ln -s "$HOME/dotfiles/nvim/init.lua" "$HOME/.config/nvim/init.lua"
mkdir -p "$HOME/.config/nvim/luasnip"
ln -s "$HOME/dotfiles/nvim/luasnip/all.lua" "$HOME/.config/nvim/luasnip/all.lua"
