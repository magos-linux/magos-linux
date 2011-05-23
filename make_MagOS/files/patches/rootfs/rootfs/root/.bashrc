# .bashrc

PATH=/usr/lib/magos/scripts:/sbin:/usr/sbin:/bin:/usr/bin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin
ENV=$HOME/.bashrc
USERNAME="root"
export USERNAME ENV PATH

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi
