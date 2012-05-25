#!/bin/bash

ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0

# free some space if pxe server are not using
[ -L /boot/initrd.gz ] && exit 0
LC_ALL=C chkconfig --list tftp | grep -q off || exit 0
rm -f /boot/initrd.gz
