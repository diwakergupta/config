#!/usr/bin/env bash

# Load RVM, if you are using it
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

# Load tmuxinator
[[ -s $HOME/.tmuxinator/scripts/tmuxinator ]] && source $HOME/.tmuxinator/scripts/tmuxinator

# Add rvm gems and nginx to the path
export PATH=$PATH:~/.gem/ruby/1.8/bin:/opt/nginx/sbin

# Path to the bash it configuration
export BASH_IT=$HOME/.bash_it

# Lock and Load a custom theme file
# location /.bash_it/themes/
export BASH_IT_THEME='minimal'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Set my editor and git editor
export EDITOR="vim"
export GIT_EDITOR='vim'

export JAVA_HOME=$(/usr/libexec/java_home)

# Add other useful PATHs.
export PATH=.:/usr/local/bin:/usr/local/sbin:~/local/bin:$PATH

# Load Bash It
source $BASH_IT/bash_it.sh
