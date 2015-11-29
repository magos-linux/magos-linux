#!/bin/bash
#speedboot tweak
[ -f /etc/ld.so.conf.d/GL/standard.conf ] || exit 0
for a in ati nvidia340 nvidia304 nvidia173 nvidia96xx nvidia-current standard ;do
  LINK=$(alternatives --list gl_conf | grep -m1 $a)
  [ -z "$LINK" ] && continue
  alternatives --quiet --set gl_conf "$LINK"
  ldconfig
  mkdir -p "/usr/share/magos/ld.so.cache/$a/etc" "/usr/share/magos/ld.so.cache/$a/var/cache/ldconfig"
  cp -p /etc/ld.so.cache      "/usr/share/magos/ld.so.cache/$a/etc"
  cp -p /var/cache/ldconfig/* "/usr/share/magos/ld.so.cache/$a/var/cache/ldconfig"
done
mv      /usr/share/magos/ld.so.cache/nvidia96xx /usr/share/magos/ld.so.cache/nvidia 2>/dev/null
mv      /usr/share/magos/ld.so.cache/ati        /usr/share/magos/ld.so.cache/fglrx
mv      /usr/share/magos/ld.so.cache/standard   /usr/share/magos/ld.so.cache/fbdev
cp -pfr /usr/share/magos/ld.so.cache/fbdev      /usr/share/magos/ld.so.cache/ati
exit 0
