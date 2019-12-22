#!/bin/bash

ROOTFS=
[ -d ${ROOTFS}usr/lib/magos ] || ROOTFS=/

#/sbin
grep -q ifup-pre-local ${ROOTFS}etc/sysconfig/network-scripts/ifup 2>/dev/null && ln -sf /usr/lib/magos/sbin/ifup-pre-local ${ROOTFS}sbin

#/etc/rc.d
INITD=${ROOTFS}etc/rc.d/init.d
[ -d $INITD ] || INITD=${ROOTFS}etc/init.d
find  ${ROOTFS}usr/lib/magos/rc.d/init.d  -type f | sed s%${ROOTFS}usr/lib/magos/rc.d/init.d/%% | while read a ;do
  ln -sf /usr/lib/magos/rc.d/init.d/$a $INITD
done

#systemd
SYSTEMDFILES=${ROOTFS}usr/lib/systemd/system
[ -d $SYSTEMDFILES ] || SYSTEMDFILES=${ROOTFS}lib/systemd/system
find ${ROOTFS}usr/lib/magos/systemd -type f | sed s%${ROOTFS}usr/lib/magos/systemd/%% | while read a ;do
  ln -sf /usr/lib/magos/systemd/$a $SYSTEMDFILES
done
ls -1d ${ROOTFS}usr/lib/magos/systemd/*.wants | sed s%${ROOTFS}usr/lib/magos/systemd/%% | while read a ;do
  mkdir -p $SYSTEMDFILES/$a
  cp -df ${ROOTFS}usr/lib/magos/systemd/$a/* $SYSTEMDFILES/$a
done

exit 0
