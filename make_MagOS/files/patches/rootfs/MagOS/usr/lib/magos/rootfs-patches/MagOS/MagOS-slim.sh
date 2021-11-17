#!/bin/bash

PFP=/etc/slim.conf
[ -f $PFP ] || exit 0

ln -sf /usr/share/magos/wallpapers/default.jpg /usr/share/slim/themes/default/background.jpg

grep -q MagOS $PFP && exit 0

DEs="LXQT,PLASMA,MATE,i3"
sed -i '1s|^|#MagOS patched\n|' $PFP
sed -i s%^default_path.*%'default_path        ./:/bin:/usr/bin:/usr/local/bin'% $PFP
sed -i s/^sessions.*/"sessions            $DEs"/ $PFP
sed -i s/^.sessions.*/"sessions            $DEs"/ $PFP
sed -i s/^.xserver_arguments.*/'xserver_arguments    -audit 0 -deferglyphs 16 -nolisten tcp'/ $PFP
sed -i s/^.default_user.*/"default_user        user"/ $PFP
sed -i s/^auto_login.*/"auto_login          yes"/ $PFP
sed -i s%^console_cmd.*%'console_cmd         /usr/bin/xvt'% $PFP

PFP=/usr/share/slim/themes/default/slim.theme
[ -f $PFP ] && sed -i s/^msg_color.*$/'msg_color               #000000'/ $PFP

exit 0
