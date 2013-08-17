# Code Directory
CODE=~/Code

# Enhance PATH to include /usr/local/bin
export PATH=/usr/local/bin:$PATH

# Increase history size, ignore duplicates
export HISTCONTROL=ignoreboth
export HISTSIZE=2500
export HISTFILESIZE=2500

# Append to history file, don't overwrite it
shopt -s histappend

# Check/update windowsize after each command
shopt -s checkwinsize

# Make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe.sh ] && export LESSOPEN="|/usr/bin/lesspipe.sh %s"

# Set the Prompt to be more reasonable
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u:\[\033[01;34m\]\w\[\033[00m\]\$ '

# Bash Aliases
alias rm='rm -i'
alias ls='ls -G'
alias ll='ls -Gla'
alias grep='grep --color=auto'
alias reup='source ~/.bash_profile'

# cd aliases
alias cd..='cd ..'
alias code='cd $CODE'
alias ~='cd ~'

# SSH Aliases
alias jssh='ssh -A -t jumphost-001.sjc1.yammer.com ssh $@'
alias vssh='ssh vagrant@www.yammer.dev'

# Vagrant Aliases
alias vhalt='cd $CODE/vagrant-dev-environment && bundle exec vagrant halt'
alias vup='cd $CODE/vagrant-dev-environment && bundle exec vagrant up'
alias vreup='cd $CODE/vagrant-dev-environment && bundle exec vagrant reload'

# Enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

bind "set completion-ignore-case on"

# Easy navigation of file system. This stuff is really good.
# http://jeroenjanssens.com/2013/08/16/quickly-navigate-your-filesystem-from-the-command-line.html

export MARKPATH=$HOME/.marks
function jump { 
    cd -P $MARKPATH/$1 2>/dev/null || echo "No such mark: $1"
}
function mark { 
    mkdir -p $MARKPATH; ln -s $(pwd) $MARKPATH/$1
}
function unmark { 
    rm -i $MARKPATH/$1 
}
function marks {
    ls -l $MARKPATH | sed 's/  / /g' | cut -d' ' -f9- | sed 's/ -/\t-/g' && echo
}

