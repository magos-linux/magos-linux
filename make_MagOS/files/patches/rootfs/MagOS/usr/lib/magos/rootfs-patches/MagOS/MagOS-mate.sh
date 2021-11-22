#!/bin/bash

[ -x /usr/bin/startmate ] || exit 0

PFP=/usr/share/applications/screensavers/personal-slideshow.desktop
sed -i s%^Exec=.*%"Exec=/usr/lib64/mate-screensaver/slideshow --location=/usr/share/magos/screensaver/Default"% $PFP
ln -sf /usr/share/magos/wallpapers/Default /usr/share/backgrounds/mate
ln -sf /usr/share/magos/wallpapers/Default /usr/share/backgrounds/cosmos

/usr/bin/glib-compile-schemas /usr/share/glib-2.0/schemas

exit 0
