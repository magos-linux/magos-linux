#!/bin/bash
PFP=/etc/xdg/plasmarc
[ -f $PFP ] || exit 0
sed -i s/^name=.*/name=magos/ $PFP
PFP=/etc/xdg/kdeglobals
cp -pf /usr/share/magos/plasma/kdeglobals $PFP
sed -i s/^ColorScheme=.*/"ColorScheme=MagOS"/ $PFP
egrep -v "^\[General\]|^Name=|^\[KDE\]|^ColorScheme=|^contrast=|^shadeSortColumn="  "/usr/share/color-schemes/MagOS.colors" >> /etc/xdg/kdeglobals

exit 0
