#!/usr/bin/env bash

# vim: set filetype=sh:

# Load shared configuration for bash/zsh
# Requires the shell-commons module
for name in 'variables.sh' 'aliases.sh' 'functions.sh' 'functions_exelonix.sh' 'ssh-login'; do
    if [ -e ~/.bash/shell-commons/$name ]; then
        source ~/.bash/shell-commons/$name
    fi
done

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

function cursorColor() {
    if [ -n "$DISPLAY" ] && command -v appres &> /dev/null; then
        echo $(appres URxvt | grep -e cursorColor | cut -f 2)
    fi
}

function translateInVT100ColorCode() {

    case $1 in
         0 )
            echo '\[\e[30m\]' ;;
         1 )
            echo '\[\e[31m\]' ;;
         2 )
            echo '\[\e[32m\]' ;;
         3 )
            echo '\[\e[33m\]' ;;
         4 )
            echo '\[\e[34m\]' ;;
         5 )
            echo '\[\e[35m\]' ;;
         6 )
            echo '\[\e[36m\]' ;;
         7 )
            echo '\[\e[37m\]' ;;
         8 )
            echo '\[\e[1;30m\]' ;;
         9 )
            echo '\[\e[1;31m\]' ;;
        10 )
            echo '\[\e[1;32m\]' ;;
        11 )
            echo '\[\e[1;33m\]' ;;
        12 )
            echo '\[\e[1;34m\]' ;;
        13 )
            echo '\[\e[1;35m\]' ;;
        14 )
            echo '\[\e[1;36m\]' ;;
        15 )
            echo '\[\e[1;37m\]' ;;
         * )
            echo '\[\e[1;31m\]' ;;
    esac
}

VT100ColorCode=$(translateInVT100ColorCode $(cursorColor))

# Prompt
GIT_PROMPT_START='${debian_chroot:+($debian_chroot)}\[\033[00;33m\]> \[\033[00m\]\u@\h:\[\033[00;00m\]\w'
GIT_PROMPT_END='\$ '
GIT_PROMPT_THEME=Custom
source ~/.bash/bash-git-prompt/gitprompt.sh

# History
export HISTSIZE=32768               # Larger bash history (allow 32³ entries; default is 500)
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoreboth
#export HISTIGNORE="ls:ls *:l:ll:h:h *:history:history *:cd:cd -:pwd:exit:date:* --help"

# enable bash completion
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
    . /etc/bash_completion
fi

precmd() {
    echo $(pwd) > $HOME/.urxvt/start_directory
}

# For preexec and precmd hooks
if [ -e ~/.bash/bash-preexec/bash-preexec.sh ]; then
   source  ~/.bash/bash-preexec/bash-preexec.sh
fi

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.bashhub/bashhub.sh ] && source ~/.bashhub/bashhub.sh
