#!/usr/bin/env bash

for name in 'variables.sh' 'aliases.sh' 'functions.sh' 'ssh-login'; do
  [ -e ~/.bash/shell-commons/$name ] && source ~/.bash/shell-commons/$name
done

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

cursorColor() {
  if [ -n "$DISPLAY" ] && command -v appres &> /dev/null; then
    echo $(appres URxvt | grep -e cursorColor | cut -f 2)
  fi
}

translateInVT100ColorCode() {
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
unset __GIT_PROMPT_DIR
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
  source /etc/bash_completion
fi

precmd() {
  echo $(pwd) > $HOME/.urxvt/start_directory
}

[ -e ~/.bash/bash-preexec/bash-preexec.sh ] && source  ~/.bash/bash-preexec/bash-preexec.sh
[ -f ~/.fzf.bash ] && source ~/.fzf.bash
[ -f ~/.bashhub/bashhub.sh ] && source ~/.bashhub/bashhub.sh

if [ -f ~/.zlua-src/z.lua ]; then
  export _ZL_CMD=zz
  eval "$(lua ~/.zlua-src/z.lua --init bash enhanced once fzf)"
  alias z="$_ZL_CMD -I"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# vim: set filetype=sh:
