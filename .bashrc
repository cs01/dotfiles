# This file assumes devbootstrap has been cloned to
DEVBOOTSTRAP=$HOME/devbootstrap  # TODO determine this dynamically

# Source any private bash files
PRIVATE_BASH_FILE=${HOME}/private/.bashrc
if [ -f  $PRIVATE_BASH_FILE ]; then
  source $PRIVATE_BASH_FILE
fi



#################################
#ENVIRONMENT VARIABLES
#################################
export PATH=".:/sbin/:/bin/:/usr/bin:$HOME/bash_scripts:/usr/local/opt/ccache/libexec:/usr/local/bin:~/bin:/opt/local/bin:/opt/local/sbin"
export INPUTRC="$DEVBOOTSTRAP/.inputrc"
export PYTHONPATH=".:/opt/local/Library/Frameworks/Python.framework/Versions/2.7/lib/python2.7/site-packages/"
export LD_LIBRARY_PATH="/usr/local/lib/"

# Python
export PYTHONSTARTUP="$DEVBOOTSTRAP/.pythonrc.py"
export PYTHONDONTWRITEBYTECODE="True"

# Preserve history across terminals
# http://unix.stackexchange.com/questions/1288/preserve-bash-history-in-multiple-terminal-windows
export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
export HISTSIZE=                   # big big history
export HISTFILESIZE=               # big big history
shopt -s histappend                      # append to history, don't overwrite it
# Save and reload the history after each command finishes
export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"



#################################
#RE-DEFINE PROMPT STRING (PS1)
#To be colorized and show git branch/commit
#################################

NORMAL=`echo -e '\033[0m'`
RED=`echo -e '\033[31m'`
GREEN=`echo -e '\033[0;32m'`
LGREEN=`echo -e '\033[1;32m'`
BLUE=`echo -e '\033[0;34m'`
LBLUE=`echo -e '\033[1;34m'`
YELLOW=`echo -e '\033[0;33m'`

# prefix with \[ to go to next line when out of space typing a command in bash
# Without the \[ \], bash will think the bytes which constitute the escape
# sequences for the color codes will actually take up space on the screen, so
# bash won't be able to know where the cursor actually is.
# http://mywiki.wooledge.org/BashFAQ/053
# source ~/.git-prompt.sh # defines the function __git_ps1

# show git branch in prompt
#\u is username
#\h is hostname
#\W Print the base of current working directory.
#\$: Display # (indicates root user) if the effective UID is 0, otherwise display a $.
function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit"* ]] && echo "*"
}
function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/(\1$(parse_git_dirty))/"
}
# Update bash prompt
export PS1='\[${BLUE}\]${PWD} \[${NORMAL}\]\u@\h\[${GREEN}\]`parse_git_branch`\[${NORMAL}\]\n>> '

if [ -f  /usr/local/bin/virtualenvwrapper.sh ]; then
  source /usr/local/bin/virtualenvwrapper.sh

  # Set up hooks to automatically enter last virtual env
  export LAST_VIRTUAL_ENV_FILE=${WORKON_HOME}/last_virtual_env
  echo -e "#!/bin/bash\n#Save this venv to be restored when a new shell opens\necho \$1 > $LAST_VIRTUAL_ENV_FILE" > $WORKON_HOME/preactivate
  echo -e "#!/bin/bash\n#Wipe saved venv\necho '' > $LAST_VIRTUAL_ENV_FILE" > $WORKON_HOME/predeactivate
  chmod +x $WORKON_HOME/preactivate
  chmod +x $WORKON_HOME/predeactivate
  # If the last virtual envfile already exists, switch to it
  if [ -f  $LAST_VIRTUAL_ENV_FILE ]; then
    # Automatically re-enter virtual environment (last line of LAST_VIRTUAL_ENV_FILE is used)
    LAST_VIRTUAL_ENV_NAME=$(tail -n 1 $LAST_VIRTUAL_ENV_FILE)
    if [ -z $LAST_VIRTUAL_ENV_NAME ]; then
      # File was blank, do nothing
      true
    else
      workon $LAST_VIRTUAL_ENV_NAME
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

# CLEARING
alias clc="clear"

# DIR NAVIGATION
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# EDIT BASH RC'S
alias br="xdg-open $HOME/.bashrc"
alias sbr="source $HOME/.bashrc"

# VARIOUS
alias fopen="xdg-open"
alias edit="subl"
alias e="edit"
alias cc="pwd | tr -d '\n' | pbcopy; echo copied working dir to clipboard"  #copy to clipboard the current working dir
alias notes="edit ~/notes.txt"
alias todo="edit ~/todo.txt"
alias sagi="sudo apt-get install"
alias resetwifi="nmcli nm wifi off && nmcli nm wifi on"

# GIT
export GIT_EDITOR="vim"
alias gits="git status"
alias gka='gitk --all --date-order &'
alias gitk='gitk 2>/dev/null'
alias gitsui='git submodule update --init --recursive'
alias gitbn='git name-rev --name-only HEAD'
alias gitmergeclean='find . -name "*.orig" | xargs rm'
alias gitcm="git commit -m "


#################################
#FUNCTIONS
#################################

#display contents of directory after entering it
function cd(){
	builtin cd "$*" && ll
}

# case sensitive search, excluding binaries
# and git directories
function gr() {
    grep --color -rIn --exclude-dir=".git" $1 .
}

# case sensitive search, excluding binaries
# and git directories
function grpat() {
    grep --include=$1 --color -rIn --exclude-dir=".git" $2 .
}

# case sensitive search, excluding binaries
# and git directories, but with context
function grc() {
    grep --color -rIn -B 2 -A 2 --exclude-dir=".git" $1 .
}

# case sensitive search, excluding binaries
# and git directories, but with context
function grcpat() {
    grep --include=$1 --color -rIn -B 2 -A 2 --exclude-dir=".git" $2 .
}

# case insensitive search, excluding binaries
# and git directories
function gri() {
    grep --color -riIn --exclude-dir=".git" $1 .
}

# case insensitive search, excluding binaries
# and git directories
function gripat() {
    grep --include=$1 --color -riIn --exclude-dir=".git" $2 .
}


# Locate all files a given name, open first one
function pew {
  chosen=`locate $1 | sed -n 1p`
  echo $chosen
  xdg-open $chosen
}

# Run locate command on argument
# then open all results returned
function pewall {
  chosen=`locate $1`
  echo -e "$chosen \n"
  xdg-open $chosen
}

# Run one or more bash commands and pipe stdout and stderr
# to a file, then open that file when complete
function textme() {
	$@ &> /tmp/textme.txt
	subl  /tmp/textme.txt
}

# Run a command once every second until cancelled
function repeat() {
  while :
  do
    $@
    sleep 1
  done
}

# Echo a command or commands, then run them
function echo_and_run {
  # echo "$@"
  eval $(printf '%q ' "$@") < /dev/tty
}
