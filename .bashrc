#!/usr/bin/env bash

for name in 'variables.sh' 'aliases.sh' 'functions.sh' 'ssh-login'; do
  [ -e ~/.bash/shell-commons/$name ] && source ~/.bash/shell-commons/$name
done

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
unset __GIT_PROMPT_DIR
GIT_PROMPT_START='${debian_chroot:+($debian_chroot)}\[\033[00;33m\]> \[\033[00m\]\u@\h:\[\033[00;00m\]\w'
GIT_PROMPT_END='\$ '
GIT_PROMPT_THEME=Custom
source ~/.bash/bash-git-prompt/gitprompt.sh

export HISTSIZE=32768               # Larger bash history (allow 32³ entries; default is 500)
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoreboth
#export HISTIGNORE="ls:ls *:l:ll:h:h *:history:history *:cd:cd -:pwd:exit:date:* --help"

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
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# vim: set filetype=sh:
