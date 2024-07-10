#!/bin/zsh

# Symlink configuration files
ln -s "$HOME/dotfiles/nvim/init.vim" "$HOME/.config/nvim/init.vim"

mkdir -p "$HOME/.config/nvim/plugin"
ln -s "$HOME/dotfiles/nvim/plugin/vimtex.vim" "$HOME/.config/nvim/plugin/vimtex.vim"

mkdir -p "$HOME/.config/nvim/ftplugin"

mkdir -p "$HOME/.config/nvim/luasnip"
ln -s "$HOME/dotfiles/nvim/luasnip/tex.lua" "$HOME/.config/nvim/luasnip/tex.lua"
