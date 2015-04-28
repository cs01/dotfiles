## About
Contains a .bashrc file, git files, and python rc files I use to save keystrokes and make life better in the terminal


## Install
1. **Clone**

  `git clone https://github.com/cs01/devbootstrap.git ~`

2. **Save current bashrc**

  `mkdir ~/private && mv ~/.bashrc ~/private/.bashrc`

3. **Install devbootstrap**

  `~/devbootstrap/install.sh`


4. **Include your original bashrc**

  `printf 'source $HOME/private/.bashrc' >> ~/.bashrc`

5. **Run your new bashrc**

  `source ~/.bashrc`