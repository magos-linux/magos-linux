#!/bin/bash
SYSCONF=/etc/sysconfig
[ -d $SYSCONF ] || SYSCONF=/etc/MagOS
ln -sf /lib/systemd/system/lightdm.service /etc/systemd/system/display-manager.service
echo -e "DESKTOP=Plasma\nDISPLAYMANAGER=lightdm" > $SYSCONF/desktop

exit 0
