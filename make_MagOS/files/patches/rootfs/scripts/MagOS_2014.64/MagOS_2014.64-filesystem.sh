#!/bin/bash
mkdir -m 755 -p run/udev/rules.d
rm -f lib/systemd/system/basic.target.wants/mandriva-boot-links.service \
      lib/systemd/system/local-fs.target.wants/fsck-root.service \
      lib/systemd/system/local-fs.target.wants/remount-rootfs.service \
      etc/systemd/system/multi-user.target.wants/shorewall.service \
      etc/xdg/autostart/parcellite-startup.desktop etc/X11/xorg.conf 2>/dev/null
exit 0
