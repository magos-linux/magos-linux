#!/bin/bash
#speedboot tweak
[ -f /etc/ld.so.conf.d/GL/standard.conf ] || exit 0
for a in nvidia550 nvidia390 standard ;do
  LINK=$(LC_ALL=C alternatives --display gl_conf | grep priority | awk '{print $1}' | grep -m1 $a)
  [ -z "$LINK" ] && continue
  echo found $LINK
  alternatives --set gl_conf "$LINK"
  ldconfig
  mkdir -p "/usr/share/magos/ld.so.cache/$a/etc" "/usr/share/magos/ld.so.cache/$a/var/cache/ldconfig"
  cp -p /etc/ld.so.cache      "/usr/share/magos/ld.so.cache/$a/etc"
  cp -p /var/cache/ldconfig/* "/usr/share/magos/ld.so.cache/$a/var/cache/ldconfig"
done
mv      /usr/share/magos/ld.so.cache/nvidia96xx /usr/share/magos/ld.so.cache/nvidia 2>/dev/null
mv      /usr/share/magos/ld.so.cache/standard   /usr/share/magos/ld.so.cache/fbdev
exit 0
