#!/bin/zsh

# Install vim-plug
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# Symlink configuration files
ln -s "$HOME/dotfiles/nvim/init.vim" "$HOME/.config/nvim/init.vim"
