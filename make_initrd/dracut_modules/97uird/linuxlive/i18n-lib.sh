#!/bin/bash
##
# Thin library around basic I18N facilitated function
#   basic text display, file logging, error display, and prompting
export TEXTDOMAINDIR=$(pwd)/locale

###############################################
##
## Display some text to stderr
## $1 is assumed to be the Message Catalog key
function i18n_error {
        echo "$(gettext -s "$1")" >&2
}

###############################################
##
## Display some text to sdtout
## $1 is assumed to be the Message Catalog key
## rest of args are used as misc information
function i18n_display {
        typeset key="$1"
        shift
        echo "$(gettext -s "$key") $@"
}

###############################################
## Append a log message to a file.
## use $1 as target file to append to
## use $2 as catalog key
## rest of args are used as misc information
function i18n_fileout {
        [[ $# -lt 2 ]] && return 1
        typeset file="$1"
        typeset key="$2"
        shift 2
        echo "$(gettext -s "$key") $@" >> ${file}
}

## Prompt the user with a message and echo back the response.
## $1 is assumed to be the Message Catalog key
function i18n_prompt {
        typeset rv
        [[ $# -lt 1 ]] && return 1
        read -p "$(gettext "$1"): " rv
        echo $rv
}
