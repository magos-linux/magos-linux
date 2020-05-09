#!/bin/bash
[ -x /usr/bin/startlxde ] || exit 0
# Default wallpaper
ln -sf /usr/share/magos/wallpapers/default.jpg /usr/share/wallpapers/default.jpg

#LXDE wallpaper
PFP=/etc/xdg/pcmanfm/LXDE/pcmanfm.conf
[ -f $PFP ] && sed -i s%wallpaper=.*%wallpaper=/usr/share/magos/wallpapers/default.jpg% $PFP
PFP=/etc/xdg/pcmanfm/default/pcmanfm.conf
[ -f $PFP ] && sed -i s%wallpaper=.*%wallpaper=/usr/share/magos/wallpapers/default.jpg% $PFP

DIROPENBOX=openbox-3
ln -sf "../MagOS/$DIROPENBOX"  "/usr/share/themes/Default/$DIROPENBOX"

PFP=/etc/xdg/lxsession/LXDE/desktop.conf
sed -i s%sNet/ThemeName=.*%sNet/ThemeName=Default% $PFP
sed -i s%sNet/IconThemeName=.*%sNet/IconThemeName=Default% $PFP
sed -i s%sGtk/CursorThemeName=.*%sGtk/CursorThemeName=Default% $PFP

[ -d /usr/share/magos/lxde/skel ] && cp -aprf /usr/share/magos/lxde/skel /etc

exit 0
