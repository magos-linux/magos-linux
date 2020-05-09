#!/bin/bash

[ -d /usr/share/icons/rosa ] && ln -sf rosa /usr/share/icons/Default

for a in `find /usr/share/icons -name icon-theme.cache` ;do
    gtk-update-icon-cache -fit "$(dirname $a)" 2>&1 | grep -v "created successfully"
done

exit 0
