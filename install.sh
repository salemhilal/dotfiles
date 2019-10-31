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

# Install git-prompt
echo "Installing git-prompt"
if [ ! -f ~/.git-prompt.sh ]; then
  curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o ~/.git-prompt.sh
fi

# Install git autocompletion
echo "Installing git-completion"
if [ ! -f ~/.git-completion.bash ]; then
  curl https://raw.githubusercontent.com/git/git/master/comtrib/completion/git-completion.bash -o ~/.git-completion.bash
fi

# Installing zsh
echo "Installing zsh and zsh-completions"
brew install zsh zsh-completions


# Install prezto and change shell to zsh
echo "Installing prezto"
if [ ! -f "${ZDOTDIR:-$HOME}/.zprezto" ]; then
    git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
    setopt EXTENDED_GLOB
    for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md; do
        ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
    done
fi

echo "Setting shell as zsh"
chsh -s $(which zsh)

echo "Installing iterm2"
brew cask install iterm2

echo "Installing powerline fonts"
brew tap homebrew/cask-fonts
brew cask install font-fira-code
brew cask install font-fira-mono-for-powerline
