#!/bin/bash

# Immediately exit on error
set -e

trap 'echo Devbootstrap did not complete installation due to an unknown error.' ERR
trap 'echo Installed devbootstrap' EXIT
if [[ "$(basename -- $0)" != "install.sh" ]]; then
  echo "Don't source this file, execute it."
  return 1
fi

DEVBOOTSTRAP_PATH=${HOME}/devbootstrap
DEVBOOSTRAP_FILES=(.input.rc .gitconfig .gconf .vimrc .bashrc)
DATE=`date +"%b-%d-%y"`

for i in "${DEVBOOSTRAP_FILES[@]}"
do
  echo "Backing up ${HOME}/${i} to  ${HOME}/${i}_${DATE}_BACKUP"
  mv ${HOME}/${i}  ${HOME}/${i}_${DATE}_BACKUP
done

for i in "${DEVBOOSTRAP_FILES[@]}"
do
  echo "Pointing ${DEVBOOTSTRAP_PATH}/${i} to ${HOME}/${i}"
  ln -sf ${DEVBOOTSTRAP_PATH}/${i} ${HOME}/${i}
done

if [ ! -d ${HOME}/private ]; then
  mkdir ${HOME}/private
  echo "Created ${HOME}/private. If there is a .bashrc file in that directory, it will be sourced from ~/.bashrc."
fi

echo "Add any private shell commands to ~/private/.bashrc"
