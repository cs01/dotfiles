# This file assumes dotfiles has been cloned to
DEVBOOTSTRAP=$HOME/dotfiles  # TODO determine this dynamically

case "$OSTYPE" in
  linux*)   PLATFORM="linux" ;;
  darwin*)  PLATFORM="mac" ;;
  win*|msys*|cygwin*)     PLATFORM="win" ;;
  *)        PLATFORM="unknown: $OSTYPE" ;;
esac


#########
# Platform specific
#########
if [[ $PLATFORM = 'linux' ]];then
  alias open="xdg-open"
  export PYTHONPATH=".:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/"
  export LD_LIBRARY_PATH="/usr/local/lib/"

elif [[ $PLATFORM = 'mac' ]];then
  venvscript="/Users/$USER/Library/Python/3.6/bin/virtualenvwrapper.sh"
  VIRTUALENVWRAPPER_PYTHON=/opt/homebrew/bin/python3
  PATH=$PATH:/Users/$USER/Library/Python/3.6/bin/
fi

# For rust
if [ -f  $HOME/.cargo/env ]; then
  source $HOME/.cargo/env
fi

# Press up/down arrows and only search for what's currently entered in terminal
# http://stackoverflow.com/a/1030206/2893090
if [[ $- == *i* ]]
then
    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
fi


#################################
#ENVIRONMENT VARIABLES
#################################
export GOPATH="$HOME/go"

PATH=$PATH:":$GOPATH/bin"
export INPUTRC="$DEVBOOTSTRAP/.inputrc"

# Python
export PYTHONSTARTUP="$DEVBOOTSTRAP/.pythonrc.py"
export PYTHONDONTWRITEBYTECODE="True"
export DJANGO_DEVELOPMENT=true

# History
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=
export HISTFILESIZE=
shopt -s histappend
# Preserve history across terminals
# http://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# Color escape sequences
NORMAL=`echo -e '\033[0m'`
RED=`echo -e '\033[31m'`
GREEN=`echo -e '\033[0;32m'`
LGREEN=`echo -e '\033[1;32m'`
BLUE=`echo -e '\033[0;34m'`
LBLUE=`echo -e '\033[1;34m'`
YELLOW=`echo -e '\033[0;33m'`

# show git branch in prompt
#\u is username
#\h is hostname
#\W Print the base of current working directory.
#\$: Display # (indicates root user) if the effective UID is 0, otherwise display a $.
parse_git_dirty() {
  [ "$(git status --porcelain 2> /dev/null)" ] && echo "*"
}
git_branch() {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}
# tab completion for git
source $HOME/dotfiles/git-completion.bash

# turn prompt into something like
# /path/to/working/dir user@macbook-pro(master*)

# prefix with \[ to go to next line when out of space typing a command in bash
# Without the \[ \], bash will think the bytes which constitute the escape
# sequences for the color codes will actually take up space on the screen, so
# bash won't be able to know where the cursor actually is.
# http://mywiki.wooledge.org/BashFAQ/053\
export PS1='\[${LBLUE}\]${PWD} \[${NORMAL}\]\u@\h\[${GREEN}\]$(git_branch)\[${NORMAL}\]
>> '

if [ -f  "$venvscript" ]; then
    source "$venvscript"

    # Set up hooks to automatically enter last virtual env
    export LAST_VENV_FILE=${WORKON_HOME}/.last_virtual_env
    echo -e "#!/bin/bash\necho \$1 > $LAST_VENV_FILE" > $WORKON_HOME/preactivate
    echo -e "#!/bin/bash\necho '' > $LAST_VENV_FILE" > $WORKON_HOME/predeactivate
    chmod +x $WORKON_HOME/preactivate
    chmod +x $WORKON_HOME/predeactivate
    if [ -f  $LAST_VENV_FILE ]; then
        LAST_VENV=$(tail -n 1 $LAST_VENV_FILE)
        if [ ! -z $LAST_VENV ]; then
            # Automatically re-enter virtual environment
            workon $LAST_VENV
        fi
    fi
fi


#################################
#COLORED LS
#################################
if [ "$(uname)" == "Linux" ]; then
	alias ls="ls --color=auto"
else
	alias ls="ls -G"
fi

#boolean that forces use of LSCOLORS
export CLICOLOR=1
#color listing, x is default, letters map to colors. see man ls
export LSCOLORS=bxFxCxDxBxegedabagacad



#################################
#BASH COMPLETION
#################################
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


#################################
#ALIASES
#################################

# LISTING
alias ll="ls -la"

# DIR NAVIGATION
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# EDIT BASH RC'S
alias br="e $HOME/.bashrc"
alias sbr="source $HOME/.bashrc"

# VARIOUS
alias edit="atom"
alias e="edit"
alias cc="pwd | tr -d '\n' | pbcopy; echo copied working dir to clipboard"  #copy to clipboard the current working dir
alias notes="edit ~/notes.txt"
alias todo="edit ~/todo.txt"
alias sagi="sudo apt-get install"
alias upgrade="sudo apt-get update && sudo apt-get upgrade"
alias resetwifi="nmcli nm wifi off && nmcli nm wifi on"

# GIT
export GIT_EDITOR="vim"
alias gits="git status"
alias gka='gitk --all --date-order &'
alias gitk='gitk 2>/dev/null'
alias gitsui='git submodule update --init --recursive'
# always show color, never search binaries or .git dirs, always search recursively
alias grep="grep --color -Ir --exclude-dir=.git"
# show surrounding lines
alias grepc="grep -B 2 -A 2"

#################################
#FUNCTIONS
#################################

#display contents of directory after entering it
cd(){
	builtin cd $@ && ls -la
}

# Run one or more bash commands and pipe stdout and stderr
# to a file, then open that file when complete
textme() {
	$@ &> /tmp/textme.txt
	edit  /tmp/textme.txt
}

# Run a command once every second until cancelled
repeat() {
  # watch does not exist by default on macs, but this works everywhere
  while :
  do
    # use eval to run in current shell so aliases like ll are
    # available
    eval "$@"
    sleep 1
  done
}

# Echo a command or commands, then run them
echo_and_run() {
  echo "$@"
  eval $(printf '%q ' "$@") < /dev/tty
}

d() {
    local search=""
    echo "duck duck go: $@"
    for term in $@; do
        search="$search%20$term"
    done
    open "http://www.duckduckgo.com/?q=$search"
}

g() {
  local search=""
  echo "google: $@"
  for term in $@; do
      search="$search%20$term"
  done
  open "http://www.google.com/search?q=$search"
}

# for colored man pages (and maybe some other unwanted side effect?)
export LESS_TERMCAP_mb=$'\E[1;31m'     # begin bold
export LESS_TERMCAP_md=$'\E[1;36m'     # begin blink
export LESS_TERMCAP_me=$'\E[0m'        # reset bold/blink
export LESS_TERMCAP_so=$'\E[01;44;33m' # begin reverse video
export LESS_TERMCAP_se=$'\E[0m'        # reset reverse video
export LESS_TERMCAP_us=$'\E[1;32m'     # begin underline
export LESS_TERMCAP_ue=$'\E[0m'        # reset underline
export GROFF_NO_SGR=1                  # for konsole and gnome-terminal


cal() {
    local year=$(date +%Y)
    if (( $# == 0 )); then
        command cal "$year"
    elif (( $# == 1 && 1 <= $1 && $1 < 13 )); then
        command cal "$1" "$year"
    else
        command cal "$@"
    fi
}

# Print each filename followed by its contents
catt() {
    for file in "$@"; do
        echo -e "\e[1;36m# $file\e[0m"
        cat "$file"
    done
}
