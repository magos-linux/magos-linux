#!/bin/bash
PFP=/etc/sudoers
sed -i s/'^Defaults.*requiretty'/'#Defaults    requiretty'/ $PFP
sed -i 's|.*secure_path = .*|Defaults    secure_path = /usr/lib/magos/scripts:/sbin:/bin:/usr/sbin:/usr/bin:|' $PFP
if ! grep -q "^%wheel ALL=(ALL) NOPASSWD: ALL" $PFP ;then
    sed -i s/'^%wheel'/'#%wheel'/ $PFP
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> $PFP
fi
grep -q "^%sudo ALL=(ALL) ALL" $PFP || echo "%sudo ALL=(ALL) ALL" >> $PFP
groupadd -r sudo
grep -q /sbin/ldconfig  $PFP || echo "%users ALL=NOPASSWD: /sbin/ldconfig" >> $PFP

exit 0
