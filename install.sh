# Git friendly - best git aliases ever
# https://github.com/jamiew/git-friendly
echo "Installing git-friendly"
bash < <( curl https://raw.github.com/jamiew/git-friendly/master/install.sh)

# Homebrew
# http://brew.sh/
brew -v >/dev/null 2>&1 || {
  echo "Installing brewh"
  ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)"
}
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
