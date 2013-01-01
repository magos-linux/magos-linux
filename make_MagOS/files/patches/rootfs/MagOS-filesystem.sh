#!/bin/bash
rm -fr etc/skel/tmp var/tmp proc sys tmp etc/fstab etc/mtab \
   usr/lib/drakx-installer-stage2/install/stage2/mdkinst.sqfs \
   etc/xdg/autostart/pulseaudio*.desktop etc/xdg/autostart/guake.desktop \
   usr/share/GeoIP/GeoLiteCity.dat \
   boot/initrd* 2>/dev/null
#   etc/samba/passdb.tdb etc/samba/secrets.tdb \
#   usr/share/GeoIP/GeoLiteCity.dat 2>/dev/null
rm -f dev/null
ln -sf ../tmp var/tmp
ln -sf /bin/true sbin/fsck.aufs
ln -sf /usr/sbin/mount.davfs sbin/mount.davfs
mknod -m 666 dev/null c 1 3
ln -sf $(ls boot/vmlinuz-* | tail -1 | sed 's|boot/||') boot/vmlinuz
ln -sf /mnt/livemedia/MagOS/initrd.gz boot/initrd.gz
ln -s /usr/bin/busybox sbin/udhcpc
chroot ./ chown root:shadow usr/lib/chkpwd/tcb_chkpwd
chmod 2711 usr/lib/chkpwd/tcb_chkpwd
exit 0
