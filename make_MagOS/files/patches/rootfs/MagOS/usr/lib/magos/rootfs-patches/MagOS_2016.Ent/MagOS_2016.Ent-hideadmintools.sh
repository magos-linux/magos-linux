#!/bin/bash
HIDEPROGS="modmnger install-helper"
for a in $HIDEPROGS  ;do
   [ -f "/usr/share/applications/$a.desktop" ] || continue
   grep -q Hidden=true "/usr/share/applications/$a.desktop" ||  sed -i s/"\[Desktop Entry\]"/"[Desktop Entry]\\nHidden=true"/ "/usr/share/applications/$a.desktop"
done

exit 0
