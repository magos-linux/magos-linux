#!/bin/bash
for a in `find usr/share/icons -type d | grep -e -E '[x/]512$|[x/]256$|/128x128$' ` ;do
   rm -fr "$a"
done
for a in `find -name icon-theme.cache` ;do
    gtk-update-icon-cache -fit "$(dirname $a)"
done
exit 0
