#!/bin/bash

sed -i s='\^\\/live\\/'='\^\\/mnt\\/live'= etc/rc.d/init.d/halt
sed -i s='\^\\/live\\/'='\^\\/mnt\\/live'= etc/rc.d/init.d/functions
sed -i s/"Halting system"/"Syncing unmounted devices and halting system"/ etc/rc.d/init.d/halt
sed -i s/" rebooting the system"/" syncing devices and rebooting"/ etc/rc.d/init.d/halt
sed -i s/'^\[ -n "$kexec_command" \]'/'sync ; \[ -n "$kexec_command" \]'/ etc/rc.d/init.d/halt
sed -i s='if \[\[ "$rootfs"'='if grep -q " /mnt/livemedia nfs " /proc/mounts || \[\[ "$rootfs"'= etc/rc.d/init.d/network
rm -f etc/sysconfig/harddrake2/previous_hw 2>/dev/null
sed -i s/'is_empty_hash_ref($previous_config);$'/'is_empty_hash_ref($previous_config); my $force = 1 if $first_run; '/ usr/share/harddrake/service_harddrake
sed -i 's|my $ret;$|my $ret; return 1 unless ( -f '\''/var/lock/subsys/local'\'' );|' usr/lib/libDrakX/do_pkgs.pm

exit 0

