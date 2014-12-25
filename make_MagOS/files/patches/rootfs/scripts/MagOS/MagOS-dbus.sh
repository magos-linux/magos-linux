#!/bin/sh
#BUGFIX Sometimes dbus package are installed with incorrect group owner
#BUGFIX It does not allow to launch any gtk apps under Gnome
PFP=lib/dbus-1/dbus-daemon-launch-helper
[ -f $PFP ] || PFP=lib64/dbus-1/dbus-daemon-launch-helper
chroot ./ /bin/chgrp messagebus /$PFP
chmod 4750 $PFP
exit 0
