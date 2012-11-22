#!/bin/bash
PFP=etc/skel/.bash_profile
if ! grep -q "/usr/lib/magos/scripts" $PFP ;then
   sed -i s%^PATH=.*%'PATH=/usr/lib/magos/scripts:$PATH:$HOME/bin\nXDG_CONFIG_HOME=$HOME/.config'% $PFP
   sed -i s%^'export PATH'.*%'export XDG_CONFIG_HOME\nexport PATH'% $PFP
   echo ulimit -c 0 >> $PFP
fi
PFP=root/.bashrc
grep -q "/usr/lib/magos/scripts" $PFP || sed -i s%^PATH=.*%'PATH=/usr/lib/magos/scripts:/sbin:/usr/sbin:/bin:/usr/bin:/usr/X11R6/bin:/usr/local/bin:/usr/local/sbin'% $PFP

exit 0
