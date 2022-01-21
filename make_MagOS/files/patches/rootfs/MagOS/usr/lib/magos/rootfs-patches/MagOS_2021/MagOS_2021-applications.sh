#!/bin/bash
for a in install-helper modmnger ;do
   [ -f "/usr/share/applications/$a.desktop" ] || continue
   sed -i /^Hidden=/d "/usr/share/applications/$a.desktop"
   echo "Hidden=true" >> "/usr/share/applications/$a.desktop"
done

exit 0
