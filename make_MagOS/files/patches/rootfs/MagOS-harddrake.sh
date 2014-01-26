#!/bin/bash
rm -f etc/sysconfig/harddrake2/previous_hw 2>/dev/null
sed -i s/'is_empty_hash_ref($previous_config);$'/'is_empty_hash_ref($previous_config); my $force = 1 if $first_run; '/ usr/share/harddrake/service_harddrake
sed -i 's|my $ret;$|my $ret; return 1 unless ( -f '\''/var/lock/subsys/local'\'' );|' usr/lib/libDrakX/do_pkgs.pm
sed -i s/'^[[:space:]]*sleep[[:space:]]*4'/'#            sleep 4'/ usr/lib/libDrakX/modules.pm
sed -i s/'^[[:space:]]*sleep[[:space:]]*5'/'#        sleep 5'/ usr/lib/libDrakX/modules.pm
sed -i s/'^[[:space:]]*Xconfig::various::setup_kms'/'#    Xconfig::various::setup_kms'/ usr/lib/libDrakX/Xconfig/main.pm
sed -i s/'^[[:space:]]*install_server('/'#    install_server('/ usr/lib/libDrakX/Xconfig/card.pm
if ! grep -q service.conf usr/lib/libDrakX/Xconfig/card.pm ;then
   sed -i 's|xdriver=(\\S+)/;|xdriver=(\\S+)/;'\\n'    my %cfg = getVarsFromSh("/etc/sysconfig/harddrake2/service.conf");'\\n'    $boot_xdriver=$cfg{XDRIVER} unless $boot_xdriver;|' usr/lib/libDrakX/Xconfig/card.pm
fi

exit 0
