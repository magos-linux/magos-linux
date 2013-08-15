#!/bin/sh
#BUGFIX Sometimes dbus package are installed with incorrect group owner
#BUGFIX It does not allow to launch any gtk apps under Gnome
chroot ./ /bin/chgrp messagebus /lib/dbus-1/dbus-daemon-launch-helper
chmod 4750 lib/dbus-1/dbus-daemon-launch-helper
exit 0
