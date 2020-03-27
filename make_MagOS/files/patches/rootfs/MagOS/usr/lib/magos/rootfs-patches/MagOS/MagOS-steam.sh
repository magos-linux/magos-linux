#!/bin/bash
# drive bar was disabled because it shows all loop devices(
[ -x /usr/bin/steam ] || exit 0
FILE=/usr/share/applications/steam.desktop
FILEBP=/usr/share/applications/steam-bp.desktop
[ -f $FILE ] && sed -i s%"Exec=/usr/bin/steam"%"Exec=/usr/lib/magos/scripts/startsteam"% $FILE
[ -f $FILEBP ] || cp -p $FILE $FILEBP
sed -i s/=Steam$/"=Steam Big Picture"/ $FILEBP
sed -i s%Exec=.*%"Exec=/usr/lib/magos/scripts/startsteam-bp"% $FILEBP

FILE=/etc/X11/wmsession.d/43STEAM
[ -f $FILE ] && exit 0
cat >>$FILE <<EOF
NAME=Steam
DESC=Steam client in bigpicture mode
EXEC=/usr/lib/magos/scripts/startsteam-bp
SCRIPT:
exec /usr/lib/magos/scripts/startsteam-bp
EOF
exit 0
