#!/bin/bash
PFP=etc/sudoers
sed -i s/'^Defaults.*requiretty'/'#Defaults    requiretty'/ $PFP
if ! grep -q "^%wheel ALL=(ALL) NOPASSWD: ALL" $PFP ;then
    sed -i s/'^%wheel'/'#%wheel'/ $PFP
    echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> $PFP
fi
exit 0
