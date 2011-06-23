#!/bin/bash
mv dev/null ../null
rm -fr var/tmp proc sys tmp etc/fstab etc/mtab ../null \
   usr/lib/drakx-installer-stage2/install/stage2/mdkinst.sqfs \
   etc/samba/passdb.tdb etc/samba/secrets.tdb \
   usr/share/applications/kde4/Welcome.desktop \
   usr/share/locale/locale-archive \
   etc/locale /usr/share/vpnpptp/wiki/Help_uk.doc \
   etc/xdg/autostart/pulseaudio*.desktop etc/xdg/autostart/guake.desktop \
   2>/dev/null
#   usr/share/GeoIP/GeoLiteCity.dat 2>/dev/null
ln -sf ../tmp var/tmp
ln -sf /bin/true sbin/fsck.aufs
ln -sf /usr/share/locale etc/locale
mknod dev/null c 1 3
exit 0
