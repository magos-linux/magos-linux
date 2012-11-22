#!/bin/bash
PFP=etc/rc.d/init.d/polipo
grep -q "\$remote_fs" $PFP && sed -i s/.\$remote_fs// $PFP
grep -q "Default-Start:" $PFP || sed -i 's|^# Description:|# Default-Start: 2 3 4 5\n# Description:|' $PFP
exit 0
