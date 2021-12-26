#!/bin/sh

set -euo pipefail

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# Install Homebrew
# http://brew.sh/
brew -v >/dev/null 2>&1 || {
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> /Users/salem/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
}
echo "Updating brew"
brew update

# Install z.sh
# z -h >/dev/null 2>&1 || {
[ -f /usr/local/bin/z.sh ]|| {
  echo "Installing z.sh"
  git clone https://github.com/rupa/z.git
  echo "Copying z.sh to /usr/local/bin..."
  cd z && sudo mv z.sh /usr/local/bin/z.sh
  cd .. && rm -rf z
}

# Installing zsh
echo "Installing zsh and zsh-completions"
brew install zsh zsh-completions

if [ ! "$SHELL" = "/bin/zsh" ]; then  
    echo "Setting shell as zsh"
    chsh -s $(which zsh)
fi

if brew ls --versions myformula > /dev/null; then
  echo "Installing iterm2..."
  brew install iterm2
fi


echo "Installing powerline fonts..."
brew tap homebrew/cask-fonts
brew install font-meslo-lg-nerd-font
brew tap homebrew/cask-fonts
brew install --cask font-iosevka


# install zplug
if [ ! -d ~/.zplug ]; then
  echo "Installing zplug..."
  curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh
fi

# install tpm (tmux package manager)
if [ ! -d ~/.tmux/plugins/tpm ]; then
  echo "Installing tpm..."
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Symlink everything
echo "Symlinking dotfiles..."
[ ! -f ~/.gitconfig ] && ln -s $SCRIPT_DIR/.gitconfig ~
[ ! -f ~/.gitconfig ] && ln -s $SCRIPT_DIR/.gitignore ~
[ ! -f ~/.gitconfig ] && ln -s $SCRIPT_DIR/.p10k.zsh ~
[ ! -f ~/.gitconfig ] && ln -s $SCRIPT_DIR/.tmux.conf ~
[ ! -f ~/.gitconfig ] && ln -s $SCRIPT_DIR/.vimrc ~
[ ! -f ~/.gitconfig ] && ln -s $SCRIPT_DIR/.vim ~
[ ! -f ~/.gitconfig ] && ln -s $SCRIPT_DIR/.zshrc ~

echo "ALL DONE! Restarting shell."
exec "$SHELL"

