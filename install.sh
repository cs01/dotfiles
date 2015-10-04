#!/bin/bash

set -e

function echo_and_run {
  echo "$@"
  eval $(printf '%q ' "$@") < /dev/tty
}

DATE=`date +"%b-%d-%y"`

# Backup, then create symlinks to input.rc, .gitconfig, .gconf
echo_and_run mv ${HOME}/.input.rc ${HOME}/.input.rc_${DATE}_BACKUP
echo_and_run ln -s ${HOME}/devbootstrap/input.rc ${HOME}/.input.rc
echo ' '

echo_and_run mv ${HOME}/.gitconfig ${HOME}/.gitconfig_${DATE}_BACKUP
echo_and_run ln -fs ${HOME}/devbootstrap/.gitconfig ${HOME}/.gitconfig
echo ' '

echo_and_run mv ${HOME}/.gconf ${HOME}/.gconf_${DATE}_BACKUP
echo_and_run ln -fs ${HOME}/devbootstrap/.gconf ${HOME}/.gconf
echo ' '

# Create a backup of the .bashrc file
echo_and_run mv ${HOME}/.bashrc ${HOME}/.bashrc_${DATE}_BACKUP
echo_and_run ln -fs ${HOME}/devbootstrap/.bashrc ${HOME}/.bashrc

if [ ! -d ${HOME}/private ]; then
  mkdir ${HOME}/private
  echo "Created ${HOME}/private"
fi



# Run the new bashrc script
source ${HOME}/.bashrc

echo "SUCCESS"
echo "~/devbootstrap/.bashrc has been sourced"
echo "You now have a new .bash rc that: has a PS1 that automatically displays which git branch you're on, has colors, new aliases, new functions, up arrow for history, history across terminals"
echo  "~/private/.bashrc will be automatically sourced as well (if it exists)"
