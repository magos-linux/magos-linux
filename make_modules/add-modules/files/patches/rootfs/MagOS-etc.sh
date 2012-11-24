#!/bin/bash
sed -i s/":3:initdefault:"/":5:initdefault:"/ etc/inittab
PFP=etc/sysctl.conf
grep -q vm.swappiness $PFP || echo -e "\nRealtime settings\nvm.swappiness=10" >> $PFP
grep -q fs.inotify.max_user_watches $PFP || echo "fs.inotify.max_user_watches = 524288" >> $PFP
PFP=etc/security/limits.conf
sed -i s/.audio.*rtprio.*/'@audio          -       rtprio           90'/ $PFP
grep -q audio.*memlock $PFP || sed -i /audio.*rtprio/s/$/'\n@audio          -       memlock          unlimited'/ $PFP
sed -i s/.audio.*memlock.*/'@audio          -       memlock          unlimited'/ $PFP

exit 0
