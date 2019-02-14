export ZSH=$HOME/.oh-my-zsh
export UPDATE_ZSH_DAYS=7

export LANG=en_US.UTF-8
export OS=`uname -s`

export EDITOR=vim
export TERM=termite
export XAUTHORITY=/home/julia/.Xauthority
export PATH="$PATH:/home/julia/.gem/ruby/2.6.0/bin"

ZSH_THEME="agnoster2"

CASE_SENSITIVE="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"
HIST_STAMPS="yyyy-mm-dd"

# vim keybinds
bindkey -v

# DISABLE_UNTRACKED_FILES_DIRTY="true"
# ZSH_CUSTOM=/path/to/new-custom-folder

plugins=( git )

source $ZSH/oh-my-zsh.sh
source $HOME/.aliases

# User configuration

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
export SSH_KEY_PATH="~/.ssh/rsa_id"

# TeX
export TEXINPUTS=":$HOME/.latex//:"

# editors
export EDITOR="vim"
