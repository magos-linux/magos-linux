#!/bin/sh
chroot ./ /bin/chown -R nx.root /etc/nxserver
chroot ./ /bin/chown -R nx.root /var/lib/nxserver
chroot ./ /usr/bin/passwd -uf nx >/dev/null 2>&1
mount -o bind /dev dev
date +%N | md5sum | cut -c 1-16  > nx.pass
chroot ./  /usr/bin/passwd -f --stdin nx <nx.pass >/dev/null 2>&1
umount dev
rm -f nx.pass


