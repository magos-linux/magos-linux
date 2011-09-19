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
sed -i s='if \[\[ "$rootfs"'='if grep -q " /mnt/livemedia nfs " /proc/mounts || \[\[ "$rootfs"'= etc/rc.d/init.d/network
rm -f etc/sysconfig/harddrake2/previous_hw 2>/dev/null
sed -i s/'is_empty_hash_ref($previous_config);$'/'is_empty_hash_ref($previous_config); my $force = 1 if $first_run; '/ usr/share/harddrake/service_harddrake
sed -i 's|my $ret;$|my $ret; return 1 unless ( -f '\''/var/lock/subsys/local'\'' );|' usr/lib/libDrakX/do_pkgs.pm
 
exit 0

