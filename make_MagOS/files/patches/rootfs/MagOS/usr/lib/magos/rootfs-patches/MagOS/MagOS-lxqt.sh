#!/bin/bash
[ -x /usr/bin/startlxqt ] || exit 0
# Default wallpaper
ln -sf /usr/share/magos/wallpapers/default.jpg /usr/share/wallpapers/default.jpg

#LXDE wallpaper
PFP=/etc/xdg/pcmanfm-qt/lxqt/settings.conf
[ -f $PFP ] && sed -i s%wallpaper=.*%wallpaper=/usr/share/magos/wallpapers/default.jpg% $PFP
PFP=/usr/share/xsessions/lxqt.desktop
[ -f $PFP ] && sed -i s%Name=.*%Name=LXQT% $PFP
PFP=/usr/share/kdm/sessions/lxqt.desktop
[ -f $PFP ] && sed -i s%Name=.*%Name=LXQT% $PFP

DIROPENBOX=openbox-3
[ -d "/usr/share/themes/Default/$DIROPENBOX" ] || ln -sf "../MagOS/$DIROPENBOX"              "/usr/share/themes/Default/$DIROPENBOX"
[ -d /usr/share/themes/Default/lxqt ]          || ln -sf "../MagOS/lxqt"                     "/usr/share/themes/Default/lxqt"
[ -d /usr/share/lxqt/themes/Default ]          || ln -sf /usr/share/themes/Default/lxqt      /usr/share/lxqt/themes/Default
[ -d /usr/share/lxqt/themes/MagOS ]            || ln -sf /usr/share/themes/MagOS/lxqt        /usr/share/lxqt/themes/MagOS
[ -d /usr/share/lxqt/themes/MagOS-green ]      || ln -sf /usr/share/themes/MagOS-green/lxqt  /usr/share/lxqt/themes/MagOS-green
[ -d /usr/share/lxqt/themes/MagOS-dark  ]      || ln -sf /usr/share/themes/MagOS-dark/lxqt   /usr/share/lxqt/themes/MagOS-dark

PFP=/etc/xdg/lxqt/lxqt.conf
[ -f $PFP ] && sed -i s%^theme=.*%theme=Default% $PFP
#sed -i s%sNet/IconThemeName=.*%sNet/IconThemeName=rosa% $PFP
#sed -i s%sGtk/CursorThemeName=.*%sGtk/CursorThemeName=rosa-flat% $PFP

PFP=/etc/xdg/lxqt/panel.conf
[ -f $PFP ] && sed -i s%apps.2.desktop=.*%'apps\\2\\desktop=/usr/share/applications/firefox.desktop'% $PFP
[ -f $PFP ] && sed -i s%apps.3.desktop=.*%'apps\\3\\desktop=/usr/share/applications/doublecmd.desktop'% $PFP

PFP=/etc/X11/wmsession.d/04LXQT
cat >>$PFP <<EOF
NAME=LXQT
DESC=LXQT Desktop
EXEC=/usr/bin/startlxqt
SCRIPT:
exec /usr/bin/startlxqt
EOF

exit 0
