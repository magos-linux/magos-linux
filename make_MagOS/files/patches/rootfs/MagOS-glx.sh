#!/bin/bash
chroot ./ /usr/sbin/alternatives --quiet --set gl_conf /etc/ld.so.conf.d/GL/standard.conf
chroot ./ /sbin/ldconfig
for a in fglrx ati nvidia173 nvidia96xx nvidia-current standard ;do
  chroot ./ /usr/sbin/alternatives --quiet --set gl_conf /etc/ld.so.conf.d/GL/standard.conf
  LINK=$(chroot ./ /usr/sbin/alternatives --list gl_conf | grep -m1 $a)
  [ -z "$LINK" ] && continue
  chroot ./ /usr/sbin/alternatives --quiet --set gl_conf "$LINK"
  chroot ./ /sbin/ldconfig
  mkdir -p "usr/share/magos/ld.so.cache/$a/etc" "usr/share/magos/ld.so.cache/$a/var/cache/ldconfig"
  cp -p etc/ld.so.cache "usr/share/magos/ld.so.cache/$a/etc"
  cp -p var/cache/ldconfig/* "usr/share/magos/ld.so.cache/$a/var/cache/ldconfig"
done
mv usr/share/magos/ld.so.cache/nvidia96xx usr/share/magos/ld.so.cache/nvidia
mv usr/share/magos/ld.so.cache/standard   usr/share/magos/ld.so.cache/fbdev
