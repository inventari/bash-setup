# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific aliases and functions
export PATH=$PATH:/opt/webwork/webwork2/bin
export WEBWORK_ROOT=/opt/webwork/webwork2

source ~/.git-prompt.sh
export GIT_PS1_SHOWDIRTYSTATE=1
#PS1="\e[0;32m\w$ \e[m"
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
WHITE=$(tput setaf 7)
RESET=$(tput sgr0)
PS1='\[$GREEN\]\w\[$YELLOW\]$(__git_ps1)\[$GREEN\]$ \[$WHITE\]'

alias ls="ls --color"
#alias rm="rm -i"
alias g++="echo; g++ -std=gnu++11"
alias ll="ls -alF"

function cs(){
  if [ $# -eq 0 ]; then
    cd && ls
  else
    cd "$*" && ls
  fi
}
alias cd='cs'

if [ -f .dir_colors ]; then
    eval $(dircolors -b ~/.dir_colors)
fi
