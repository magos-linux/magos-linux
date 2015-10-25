#!/bin/bash
rm -fr etc/skel/tmp var/tmp proc sys tmp etc/fstab etc/mtab \
   usr/lib/drakx-installer-stage2/install/stage2/mdkinst.sqfs \
   etc/xdg/autostart/pulseaudio*.desktop etc/xdg/autostart/guake.desktop \
   usr/share/GeoIP/GeoLiteCity.dat \
   usr/share/mdk/desktop/free/* usr/share/mdk/desktop/one/*  usr/share/mdk/desktop/powerpack/* \
   usr/share/apps/kio_desktop/DesktopLinks/* \
   usr/share/doc/rosa-media-player/*.jpg usr/share/vpnpptp/wiki/*_uk.doc \
   usr/share/doc/proftpd/Configuration.pdf usr/share/doc/easytag/users_* usr/share/doc/easytag/*_Documentation_* \
   usr/share/doc/djvulibre/doc usr/share/doc/initscripts/ChangeLog* usr/share/doc/libglib2.0-devel/ChangeLog \
   usr/share/doc/plasma-applet-stackfolder usr/share/doc/glibc/ChangeLog* \
   usr/share/doc/HTML/ru/marble usr/share/doc/HTML/ru/kalzium usr/share/doc/HTML/ru/kigo \
   usr/share/doc/HTML/ru/kstars usr/share/doc/HTML/ru/kbruch usr/share/doc/HTML/ru/akregator \
   usr/share/help/C/cheese/figures/effects.png \
   boot/initrd* usr/share/doc/perl-Libconf/html/Libconf/Libconf 2>/dev/null
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
[ -f usr/lib/chkpwd/tcb_chkpwd ] && chroot ./ chown root:shadow usr/lib/chkpwd/tcb_chkpwd && chmod 2711 usr/lib/chkpwd/tcb_chkpwd
[ -f usr/lib64/chkpwd/tcb_chkpwd ] && chroot ./ chown root:shadow usr/lib64/chkpwd/tcb_chkpwd && chmod 2711 usr/lib64/chkpwd/tcb_chkpwd

mkdir -m 755 -p run/udev/rules.d
rm -f lib/systemd/system/basic.target.wants/mandriva-boot-links.service \
      lib/systemd/system/local-fs.target.wants/fsck-root.service \
      lib/systemd/system/local-fs.target.wants/remount-rootfs.service \
      etc/systemd/system/multi-user.target.wants/shorewall.service \
      etc/xdg/autostart/parcellite-startup.desktop etc/X11/xorg.conf 2>/dev/null
exit 0
