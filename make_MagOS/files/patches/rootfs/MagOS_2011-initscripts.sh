#!/bin/bash
PFP=etc/rc.d/rc.sysinit
sed -i s/'\[ "$dmraidsets" != "no raid disks" \]'/'\[ "$dmraidsets" != "no raid disks" -a "$dmraidsets" != "no block devices found" \]'/ $PFP
sed -i s+'^PLYMOUTH=$'+'PLYMOUTH= ; /bin/setfont `grep ^SYSFONT= /etc/sysconfig/i18n | awk -F= '\''{print $2}'\''`'+ $PFP
grep -q rc.post.MagOS $PFP || echo "/etc/rc.d/rc.post.MagOS" >> $PFP
sed -i s='\^\\/live\\/'='\^\\/mnt\\/live'= etc/rc.d/init.d/functions
PFP=etc/rc.d/init.d/halt
sed -i s='\^\\/live\\/'='\^\\/mnt\\/live'= $PFP
sed -i s/"Halting system"/"Syncing unmounted devices and halting system"/ $PFP
sed -i s/" rebooting the system"/" syncing devices and rebooting"/ $PFP
sed -i s/'^\[ -n "$kexec_command" \]'/'sync ; \[ -n "$kexec_command" \]'/ $PFP
exit 0

