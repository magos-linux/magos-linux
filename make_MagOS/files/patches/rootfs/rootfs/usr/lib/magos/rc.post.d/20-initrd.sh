#!/bin/bash

ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0

# free some space if pxe server are not using
if [ -d /mnt/livemedia/MagOS ] ;then
  rm -f /boot/initrd.gz /boot/vmlinuz
  if LC_ALL=C chkconfig --list tftp 2>/dev/null | grep -q off ;then
    ln -sf /mnt/livemedia/MagOS/initrd.gz /boot
    ln -sf /mnt/livemedia/MagOS/vmlinuz   /boot
  else
    cp -pf /mnt/livemedia/MagOS/initrd.gz /boot
    cp -pf /mnt/livemedia/MagOS/vmlinuz   /boot
  fi
fi
