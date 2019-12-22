#!/bin/bash
#BUGFIX
PFP=/etc/rc.d/init.d/polipo
[ -f $PFP ] || PFP=/etc/init.d/polipo
[ -f $PFP ] || exit 0
grep -q "\$remote_fs" $PFP && sed -i s/.\$remote_fs// $PFP
grep -q "Default-Start:" $PFP || sed -i 's|^# Description:|# Default-Start: 2 3 4 5\n# Description:|' $PFP
exit 0
