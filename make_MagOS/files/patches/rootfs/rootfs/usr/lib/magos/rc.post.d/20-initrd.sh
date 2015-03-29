#!/bin/bash

ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0

DEBUGMODE=no
. /liblinuxlive  2>/dev/null || . /mnt/live/liblinuxlive
debug_mode "$0" "$@"


# free some space if pxe server are not using
if [ -d /mnt/livemedia/MagOS ] ;then
  rm -f /boot/initrd.gz /boot/vmlinuz /boot/uird.magos.cpio.xz
  if LC_ALL=C chkconfig --list tftp 2>/dev/null | grep -q off ;then
    ln -sf /mnt/livemedia/MagOS/initrd.gz /boot
    ln -sf /mnt/livemedia/MagOS/vmlinuz   /boot
    ln -sf /mnt/livemedia/MagOS/uird.magos.cpio.xz /boot
  else
    cp -pf /mnt/livemedia/MagOS/initrd.gz /boot
    cp -pf /mnt/livemedia/MagOS/vmlinuz   /boot
    cp -pf /mnt/livemedia/MagOS/uird.magos.cpio.xz /boot
  fi
fi
