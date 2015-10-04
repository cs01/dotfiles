#!/bin/bash

# Exit on any error
set -e

DATE=`date +"%b-%d-%y"`

# Backup, then create symlinks to input.rc, .gitconfig, .gconf
mv ${HOME}/.input.rc ${HOME}/.input.rc_${DATE}_BACKUP
ln -s ${HOME}/devbootstrap/input.rc ${HOME}/.input.rc

mv ${HOME}/.gitconfig ${HOME}/.gitconfig_${DATE}_BACKUP
ln -s ${HOME}/devbootstrap/.gitconfig ${HOME}/.gitconfig

mv ${HOME}/.gconf ${HOME}/.gconf_${DATE}_BACKUP
ln -s ${HOME}/devbootstrap/.gconf ${HOME}/.gconf

# Create a backup of the .bashrc file
mv ${HOME}/.bashrc ${HOME}/.bashrc_${DATE}_BACKUP
ln -s ${HOME}/devbootstrap/.bashrc ${HOME}/.bashrc

if [ ! -d ${HOME}/private ]; then
  mkdir ${HOME}/private
  echo "Created ${HOME}/private"
fi


NORMAL=`echo -e '\033[0m'`
GREEN=`echo -e '\033[0;32m'`

echo "${GREEN}devbootstrap has been installed. You must restart your terminal now or run 'source ${HOME}/.bashrc'${NORMAL}"
echo ' '
echo "You now have a new .bashrc that:"
echo "has a PS1 that automatically displays which git branch you're on, has colors, new aliases, new functions, up arrow for history, history across terminals"
echo  -e "Place any user-specific or private shell commands in ~/private/.bashrc"

