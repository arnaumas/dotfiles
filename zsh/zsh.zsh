#!/bin/zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install pure
mkdir "$HOME/.zsh"
git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure

# Create symlinks
ln -s "$HOME/dotfiles/zsh/zshrc" "$HOME/.zshrc"
