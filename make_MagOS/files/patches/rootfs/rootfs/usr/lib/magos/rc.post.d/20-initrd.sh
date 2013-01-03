#!/bin/bash

ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0

# free some space if pxe server are not using
LC_ALL=C chkconfig --list tftp | grep -q off && exit 0
[ -d /mnt/livemedia/MagOS ] || exit 0
rm -f /boot/initrd.gz /boot/vmlinuz
cp -pf /mnt/livemedia/MagOS/initrd.gz /boot
cp -pf /mnt/livemedia/MagOS/vmlinuz   /boot
