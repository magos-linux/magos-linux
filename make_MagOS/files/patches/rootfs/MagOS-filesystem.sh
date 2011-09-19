#!/bin/bash
mv dev/null ../null
rm -fr var/tmp proc sys tmp etc/fstab etc/mtab ../null \
   usr/lib/drakx-installer-stage2/install/stage2/mdkinst.sqfs \
   etc/xdg/autostart/pulseaudio*.desktop etc/xdg/autostart/guake.desktop \
   2>/dev/null
#   etc/samba/passdb.tdb etc/samba/secrets.tdb \
#   usr/share/GeoIP/GeoLiteCity.dat 2>/dev/null
ln -sf ../tmp var/tmp
ln -sf /bin/true sbin/fsck.aufs
mknod dev/null c 1 3
exit 0
