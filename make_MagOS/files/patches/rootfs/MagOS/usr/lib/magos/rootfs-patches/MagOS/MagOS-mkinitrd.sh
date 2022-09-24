#!/bin/bash
[ -h /sbin/mkinitrd ] && rm -f /sbin/mkinitrd
[ -h /usr/sbin/mkinitrd ] && rm -f /usr/sbin/mkinitrd
[ -x /sbin/mkinitrd ] && mv /sbin/mkinitrd /sbin/mkinitrd.orig
[ -x /usr/sbin/mkinitrd ] && mv /usr/sbin/mkinitrd /usr/sbin/mkinitrd.orig
/usr/lib/magos/scripts/mkinitrd /boot/initrd.gz
rm -f /lib/modules/*-*/modules.pcimap
exit 0
