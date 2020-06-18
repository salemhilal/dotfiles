#!/bin/sh

# Install Homebrew
# http://brew.sh/
brew -v >/dev/null 2>&1 || {
  echo "Installing Homebrew"
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
}
echo "Updating brew"
brew update

# Install z.sh
z -h >/dev/null 2>&1 || {
  echo "Installing z.sh"
  git clone https://github.com/rupa/z.git
  cd z && mv z.sh /usr/local/bin/z.sh
  cd .. && rm -rf z
}

# Installing zsh
echo "Installing zsh and zsh-completions"
brew install zsh zsh-completions

echo "Setting shell as zsh"
chsh -s $(which zsh)

echo "Installing iterm2"
brew cask install iterm2

echo "Installing powerline fonts"
brew tap homebrew/cask-fonts
brew cask install font-fira-code
brew cask install font-fira-mono-for-powerline

# install zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# install tpm (tmux package manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

