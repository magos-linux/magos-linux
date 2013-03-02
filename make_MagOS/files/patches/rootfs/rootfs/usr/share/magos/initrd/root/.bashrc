# .bashrc
PATH=.:/:/usr/sbin:/usr/bin:/sbin:/bin
ENV=$HOME/.bashrc
USERNAME="root"
export USERNAME ENV PATH

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
