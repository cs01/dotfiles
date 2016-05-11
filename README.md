## About
Contains a .bashrc file, git files, and python rc files I use to save keystrokes and make life better in the terminal

## Install

  	git clone https://github.com/cs01/devbootstrap.git ~/devbootstrap
    ~/devbootstrap/install.sh
    source ~/.bashrc

## Enjoy

* Display working dir, user, host, and git branch in prompt
* List directory contents automatically when entering directory
* Tab-completion
* Colored directory listings
* `virtualenvwrapper` works automatically if you're into that. It also automatically sets up the last virtual environment that was used.
* Handy aliases like `repeat`, `pew`, `gr`

## Private .bashrc
`~/private/.bashrc` will be sourced at startup if it exists for any private or computer-sepecific commands.