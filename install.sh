#!/bin/bash

if [[ "$(basename -- $0)" == "install.sh" ]]; then
  echo "Don't run $0, source it: source install.sh"
  exit 1
fi

DATE=`date +"%b-%d-%y"`

# Backup, then create symlinks to input.rc, .gitconfig, .gconf, and .bashrc
mv ${HOME}/.input.rc ${HOME}/.input.rc_${DATE}_BACKUP
ln -s ${HOME}/devbootstrap/input.rc ${HOME}/.input.rc

mv ${HOME}/.gitconfig ${HOME}/.gitconfig_${DATE}_BACKUP
ln -s ${HOME}/devbootstrap/.gitconfig ${HOME}/.gitconfig

mv ${HOME}/.gconf ${HOME}/.gconf_${DATE}_BACKUP
ln -s ${HOME}/devbootstrap/.gconf ${HOME}/.gconf

# Create a backup of the .bashrc file
echo 'Note: Recommend moving your current .bashrc file to ~/private/.bashrc. A backup is being created now.'
mv ${HOME}/.bashrc ${HOME}/.bashrc_${DATE}_BACKUP
ln -s ${HOME}/devbootstrap/.bashrc ${HOME}/.bashrc

if [ ! -d ${HOME}/private ]; then
  mkdir ${HOME}/private
  echo "Created ${HOME}/private"
fi


source ~/devbootstrap/.bashrc

echo "${GREEN}devbootstrap has been installed. Any open terminals may have to be restarted.${NORMAL}"
echo ' '
echo "You now have a new .bashrc that:"
echo "has a PS1 that automatically displays which git branch you're on, has history and tab completion across terminals, semantic colors, new aliases, new functions"
echo  -e "If you haven't already, place any user-specific or private shell commands in ~/private/.bashrc"

