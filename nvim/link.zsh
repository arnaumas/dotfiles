#!/bin/zsh

# Symlink configuration files
# ln -s "$HOME/dotfiles/nvim/init.lua" "$HOME/.config/nvim/init.lua"
ln -s "$HOME/dotfiles/nvim/init.vim" "$HOME/.config/nvim/init.vim"
mkdir -p "$HOME/.config/nvim/luasnip"
ln -s "$HOME/dotfiles/nvim/luasnip/all.lua" "$HOME/.config/nvim/luasnip/all.lua"

sh -c 'curl -fLo "$HOME/.config/nvim/autoload/plug.vim" --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
