#!/bin/bash
chroot ./ /usr/sbin/alternatives --quiet --set gl_conf /etc/ld.so.conf.d/GL/standard.conf
chroot ./ /sbin/ldconfig
for a in ati nvidia340 nvidia304 nvidia173 nvidia96xx nvidia-current standard ;do
  chroot ./ /usr/sbin/alternatives --quiet --set gl_conf /etc/ld.so.conf.d/GL/standard.conf
  LINK=$(chroot ./ /usr/sbin/alternatives --list gl_conf | grep -m1 $a)
  [ -z "$LINK" ] && continue
  chroot ./ /usr/sbin/alternatives --quiet --set gl_conf "$LINK"
  chroot ./ /sbin/ldconfig
  mkdir -p "usr/share/magos/ld.so.cache/$a/etc" "usr/share/magos/ld.so.cache/$a/var/cache/ldconfig"
  cp -p etc/ld.so.cache "usr/share/magos/ld.so.cache/$a/etc"
  cp -p var/cache/ldconfig/* "usr/share/magos/ld.so.cache/$a/var/cache/ldconfig"
done
[ -d usr/share/magos/ld.so.cache/nvidia96xx ] && mv usr/share/magos/ld.so.cache/nvidia96xx usr/share/magos/ld.so.cache/nvidia
mkdir -p usr/share/magos/ld.so.cache/fglrx/etc usr/share/magos/ld.so.cache/fbdev/etc
mv usr/share/magos/ld.so.cache/standard/etc/ld.so.cache usr/share/magos/ld.so.cache/fbdev/etc
mv usr/share/magos/ld.so.cache/standard/var             usr/share/magos/ld.so.cache/fbdev
mv usr/share/magos/ld.so.cache/ati/etc/ld.so.cache      usr/share/magos/ld.so.cache/fglrx/etc
mv usr/share/magos/ld.so.cache/ati/var                  usr/share/magos/ld.so.cache/fglrx
cp -pfr usr/share/magos/ld.so.cache/fbdev/etc/ld.so.cache usr/share/magos/ld.so.cache/ati/etc
cp -pfr usr/share/magos/ld.so.cache/fbdev/var             usr/share/magos/ld.so.cache/ati
rm -fr usr/share/magos/ld.so.cache/standard
