# Don't define aliases in plain Bourne shell
[ -n "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ] || return 0
PS14ROOT="\[\033[0;0;1;31m\]\h \[\033[0m\]\[\033[0;0;1;34m\]\W # \[\033[0m\]"
PS14USER="\[\033[0;0;1;32m\]\u@\h \[\033[0m\]\[\033[0;0;1;34m\]\W \$ \[\033[0m\]"
if [ "$PS1" -a -w /root -a "$PS14ROOT" != "DEFAULT" ]; then
    PS1="$PS14ROOT"
elif [ "$PS1" -a "$PS14USER" != "DEFAULT" ]; then
    PS1="$PS14USER"
fi
unset PS14ROOT PS14USER