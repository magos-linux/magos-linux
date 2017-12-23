#!/bin/bash

PFP=/etc/sddm.conf
[ -f $PFP ] || exit 0
sed -i s%^Current=.*%Current=magos% $PFP
sed -i s%^Session=.*%Session=default.desktop% $PFP
#sed -i s%^Relogin=.*%Relogin=true% $PFP

[ -f /usr/share/magos/wallpapers/default.jpg ] && ln -sf /usr/share/magos/wallpapers/default.jpg /usr/share/sddm/themes/elarun/images/background.png
[ -f /usr/share/sddm/themes/maldives/background.jpg ] && ln -sf /usr/share/magos/wallpapers/default.jpg /usr/share/sddm/themes/maldives/background.jpg
PFP=/usr/share/sddm/themes/elarun/theme.conf
[ -f $PFP ] && sed -i s%^background=.*%background=/usr/share/magos/wallpapers/default.jpg% $PFP
PFP=/usr/share/sddm/themes/maldives/theme.conf
[ -f $PFP ] && sed -i s%^background=.*%background=/usr/share/magos/wallpapers/default.jpg% $PFP
sed -i s/" root root "/" sddm sddm "/ /usr/lib/tmpfiles.d/sddm.conf
PFP=/lib/systemd/system/sddm.service
grep -q EnvironmentFile $PFP || sed -i 's|^ExecStart=|EnvironmentFile=/etc/sysconfig/sddm\nExecStart=|' $PFP


exit 0
