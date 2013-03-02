# Don't define aliases in plain Bourne shell
[ -n "${BASH_VERSION}${KSH_VERSION}${ZSH_VERSION}" ] || return 0
alias mc='. /usr/lib/mc/mc-wrapper.sh'

if [ "$PS1" ]  && [ -n "$BASH" ]; then
    # work around mc history issues (#59547)
    # see also https://midnight-commander.org/ticket/2104 for other solutions
    # and workarounds
    HISTIGNORE=" cd \"\`*: PROMPT_COMMAND=?*?"
fi
