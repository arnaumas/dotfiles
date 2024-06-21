#!/bin/zsh

# Install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install pure
mkdir ~/.zsh
git clone https://github.com/sindresorhus/pure.git ~/.zsh/pure
