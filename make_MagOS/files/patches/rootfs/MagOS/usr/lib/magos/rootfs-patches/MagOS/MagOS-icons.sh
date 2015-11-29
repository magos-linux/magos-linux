#!/bin/bash
for a in `find /usr/share/icons -name icon-theme.cache` ;do
    gtk-update-icon-cache -fit "$(dirname $a)"
done
exit 0
