#!/usr/bin/env bash

for name in 'variables.sh' 'aliases.sh' 'functions.sh' 'ssh-login'; do
  [ -s ~/.bash/shell-commons/$name ] && source ~/.bash/shell-commons/$name
done

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Prompt
unset __GIT_PROMPT_DIR
GIT_PROMPT_START='${debian_chroot:+($debian_chroot)}\[\033[00;33m\]> \[\033[00m\]\u@\h:\[\033[00;00m\]\w'
GIT_PROMPT_END='\$ '
GIT_PROMPT_THEME=Custom
[ -s ~/.bash/bash-git-prompt/gitprompt.sh ] && source ~/.bash/bash-git-prompt/gitprompt.sh

export HISTSIZE=32768               # Larger bash history (allow 32³ entries; default is 500)
export HISTFILESIZE=$HISTSIZE
export HISTCONTROL=ignoreboth
#export HISTIGNORE="ls:ls *:l:ll:h:h *:history:history *:cd:cd -:pwd:exit:date:* --help"

if [ -s /etc/bash_completion ] && ! shopt -oq posix; then
  source /etc/bash_completion
fi

precmd() {
  echo $(pwd) > $HOME/.config/alacritty/start_directory
}

[ -s ~/.bash/bash-preexec/bash-preexec.sh ] && source  ~/.bash/bash-preexec/bash-preexec.sh
[ -s ~/.fzf.bash ] && source ~/.fzf.bash
[ -s ~/.bashhub/bashhub.sh ] && source ~/.bashhub/bashhub.sh

if [ -s ~/.zlua-src/z.lua ]; then
  export _ZL_CMD=zz
  eval "$(lua ~/.zlua-src/z.lua --init bash enhanced once fzf)"
  alias z="$_ZL_CMD -I"
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

[ -s ~/.local/google-cloud-sdk/path.bash.inc ] && source ~/.local/google-cloud-sdk/path.bash.inc
[ -s ~/.local/google-cloud-sdk/completion.bash.inc ] && source ~/.local/google-cloud-sdk/completion.bash.inc

command -v kubectl >/dev/null 2>&1 && source <(kubectl completion bash) && complete -F __start_kubectl k
# vim: set filetype=sh:
