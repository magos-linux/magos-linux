#!/bin/bash
for a in `find -name icon-theme.cache` ;do
#   rm -f  "$a"
    gtk-update-icon-cache -fit "$(dirname $a)"
done
exit 0