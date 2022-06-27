#!/bin/sh

# Much of this file is courtesy of paulirish's dotfiles
# https://github.com/paulirish/dotfiles/blob/main/symlink-setup.sh


answer_is_yes() {
    [[ "$REPLY" =~ ^[Yy]$ ]] \
        && return 0 \
        || return 1
}

ask() {
    print_question "$1"
    read
}

ask_for_confirmation() {
    print_question "$1 (y/n) "
    read -n 1
    printf "\n"
}

ask_for_sudo() {

    # Ask for the administrator password upfront
    sudo -v

    # Update existing `sudo` time stamp until this script has finished
    # https://gist.github.com/cowboy/3118588
    while true; do
        sudo -n true
        sleep 60
        kill -0 "$$" || exit
    done &> /dev/null &

}

cmd_exists() {
    [ -x "$(command -v "$1")" ] \
        && printf 0 \
        || printf 1
}

execute() {
    $1 &> /dev/null
    print_result $? "${2:-$1}"
}

get_answer() {
    printf "$REPLY"
}

get_os() {

    declare -r OS_NAME="$(uname -s)"
    local os=""

    if [ "$OS_NAME" == "Darwin" ]; then
        os="osx"
    elif [ "$OS_NAME" == "Linux" ] && [ -e "/etc/lsb-release" ]; then
        os="ubuntu"
    fi

    printf "%s" "$os"

}

is_git_repository() {
    [ "$(git rev-parse &>/dev/null; printf $?)" -eq 0 ] \
        && return 0 \
        || return 1
}

mkd() {
    if [ -n "$1" ]; then
        if [ -e "$1" ]; then
            if [ ! -d "$1" ]; then
                print_error "$1 - a file with the same name already exists!"
            else
                print_success "$1"
            fi
        else
            execute "mkdir -p $1" "$1"
        fi
    fi
}

print_error() {
    # Print output in red
    printf "\e[0;31m  [✖] $1 $2\e[0m\n"
}

print_info() {
    # Print output in purple
    printf "\n\e[0;35m $1\e[0m\n\n"
}

print_question() {
    # Print output in yellow
    printf "\e[0;33m  [?] $1\e[0m"
}

print_result() {
    [ $1 -eq 0 ] \
        && print_success "$2" \
        || print_error "$2"

    [ "$3" == "true" ] && [ $1 -ne 0 ] \
        && exit
}

print_success() {
    # Print output in green
    printf "\e[0;32m  [✔] $1\e[0m\n"
}


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
echo "Installing tpm..."
if [ ! -d "~/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
git --git-dir=~/.tmux/plugins/tpm pull


declare -a FILES_TO_SYMLINK=$(find . -type f -maxdepth 1 -name ".*" -not -name .DS_Store -not -name .git -not -name .macos | sed -e 's|//|/|' | sed -e 's|./.|.|' | sort)
FILES_TO_SYMLINK="$FILES_TO_SYMLINK .vim" # add in vim 
# FILES_TO_SYMLINK="$FILES_TO_SYMLINK bin" # if I ever put binaries in here (i should), uncomment this line.

main() {

    local i=""
    local sourceFile=""
    local targetFile=""

    for i in ${FILES_TO_SYMLINK[@]}; do

        sourceFile="$(pwd)/$i"
        targetFile="$HOME/$(printf "%s" "$i" | sed "s/.*\/\(.*\)/\1/g")"

        if [ -e "$targetFile" ]; then
            if [ "$(readlink "$targetFile")" != "$sourceFile" ]; then

                ask_for_confirmation "'$targetFile' already exists, do you want to overwrite it?"
                if answer_is_yes; then
                    rm -rf "$targetFile"
                    execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
                else
                    print_error "$targetFile → $sourceFile"
                fi

            else
                print_success "$targetFile → $sourceFile"
            fi
        else
            execute "ln -fs $sourceFile $targetFile" "$targetFile → $sourceFile"
        fi

    done

}

main
