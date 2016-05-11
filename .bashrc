#!/usr/bin/env bash

# Load shared configuration for bash/zsh
# Requires the shell-commons module
# (see: )
for name in 'variables' 'aliases' 'functions' 'ssh-login'; do
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
export PROMPT_COMMAND=__prompt_command 
function __prompt_command() {
    local rc="$?"
    PS1="${VT100ColorCode}"

    if [ ${rc} != 0 ]; then
        PS1+="${rc}\n"
    fi

    PS1+=">\[\e[m\] \u@\h \W\$ "
}

# History
export HISTSIZE=32768               # Larger bash history (allow 32³ entries; default is 500)
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoredups
export HISTIGNORE="ls:ls *:l:ll:h:h *:history:history *:cd:cd -:pwd:exit:date:* --help"

# vim: set filetype=sh:
