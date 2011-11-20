#!/bin/bash
# free some space if pxe server are not using
[ -L /boot/initrd.gz ] && exit 0
LC_ALL=C chkconfig --list tftp | grep -q off || exit 0
rm -f /boot/initrd.gz
exit 0
