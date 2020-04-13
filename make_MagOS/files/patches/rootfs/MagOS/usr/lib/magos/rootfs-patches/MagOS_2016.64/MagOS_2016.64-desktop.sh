#!/bin/bash
SYSCONF=/etc/sysconfig
[ -d $SYSCONF ] || SYSCONF=/etc/MagOS
ln -sf /lib/systemd/system/sddm.service /etc/systemd/system/display-manager.service
echo -e "DESKTOP=Plasma" > $SYSCONF/desktop

exit 0
