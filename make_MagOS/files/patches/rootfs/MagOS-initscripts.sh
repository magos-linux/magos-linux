#!/bin/bash
sed -i s/'\[ "$dmraidsets" != "no raid disks" \]'/'\[ "$dmraidsets" != "no raid disks" -a "$dmraidsets" != "no block devices found" \]'/ etc/rc.d/rc.sysinit
sed -i s+'^PLYMOUTH=$'+'PLYMOUTH= ; /bin/setfont `grep ^SYSFONT= /etc/sysconfig/i18n | awk -F= '\''{print $2}'\''`'+ etc/rc.d/rc.sysinit


