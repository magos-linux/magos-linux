#!/bin/bash
rm -f etc/sysconfig/harddrake2/previous_hw 2>/dev/null
sed -i s/'is_empty_hash_ref($previous_config);$'/'is_empty_hash_ref($previous_config); my $force = 1 if $first_run; '/ usr/share/harddrake/service_harddrake
sed -i 's|my $ret;$|my $ret; return 1 unless ( -f '\''/var/lock/subsys/local'\'' );|' usr/lib/libDrakX/do_pkgs.pm
 
exit 0

