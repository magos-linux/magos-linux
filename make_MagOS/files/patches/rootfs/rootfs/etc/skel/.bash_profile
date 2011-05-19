# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

PATH=/usr/lib/magos/scripts:$PATH:$HOME/bin
XDG_CONFIG_HOME=$HOME/.config

export XDG_CONFIG_HOME
export PATH
unset USERNAME
ulimit -c 0
