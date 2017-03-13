#!/bin/bash

# Immediately exit on error
set -e

trap 'echo Devbootstrap did not complete installation due to an unknown error.' ERR

DESIRED_DOTFILES_PATH=${HOME}/dotfiles
ACTUAL_DOTFILES_PATH=`dirname $0`
# echo
if [ ! $DESIRED_DOTFILES_PATH -ef $ACTUAL_DOTFILES_PATH ]; then
  echo "dotfiles must be cloned to $DOTFILES_PATH. Exiting."
  exit  1
fi


DOTFILES_PATH=${HOME}/dotfiles
if [ ! -d  $DOTFILES_PATH ]; then
  echo "dotfiles must be cloned to $DOTFILES_PATH. Exiting."
  exit  1
fi


DEVBOOSTRAP_FILES=(.input.rc .gitconfig .gconf .vimrc .bashrc .vim)
DATE=`date +"%b-%d-%y"`

for i in "${DEVBOOSTRAP_FILES[@]}"
do
  if [ -f ${HOME}/${i} ]; then
    echo "Backing up ${HOME}/${i} to  ${HOME}/${i}_${DATE}_BACKUP"
    mv ${HOME}/${i}  ${HOME}/${i}_${DATE}_BACKUP
  fi
done

for i in "${DEVBOOSTRAP_FILES[@]}"
do
  echo "Pointing ${DOTFILES_PATH}/${i} to ${HOME}/${i}"
  ln -sf ${DOTFILES_PATH}/${i} ${HOME}/${i}
done

if [ ! -d ${HOME}/private ]; then
  mkdir ${HOME}/private
  echo "Created ${HOME}/private. If there is a .bashrc file in that directory, it will be sourced from ~/.bashrc."
fi

echo "Installed dotfiles. Restart shell to see changes."
echo "Note: A private file ~/private/.bashrc will be automatically sourced at startup if it exists."
