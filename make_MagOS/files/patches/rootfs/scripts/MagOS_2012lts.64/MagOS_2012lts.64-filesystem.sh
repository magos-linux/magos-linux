#!/bin/bash
mkdir -m 755 -p run/udev/rules.d run/lock
rm -f lib/systemd/system/basic.target.wants/mandriva-boot-links.service \
      lib/systemd/system/local-fs.target.wants/fsck-root.service \
      lib/systemd/system/local-fs.target.wants/remount-rootfs.service \
      etc/systemd/system/multi-user.target.wants/shorewall.service
rm -f var/lib/hsqldb/lib/hsqldb.jar
ln -sf ../../../../usr/share/java/hsqldb.jar var/lib/hsqldb/lib/hsqldb.jar
exit 0
