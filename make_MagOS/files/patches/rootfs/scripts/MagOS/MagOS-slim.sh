#!/bin/bash
PFP=etc/slim.conf
grep -q MagOS $PFP && exit 0
sed -i '1s|^|#MagOS patched\n|' $PFP
sed -i s%^default_path.*%'default_path        ./:/bin:/usr/bin:/usr/local/bin'% $PFP
sed -i s/^sessions.*/"sessions            LXDE,GNOME,KDE4"/ $PFP
sed -i s/^.sessions.*/"sessions            LXDE,GNOME,KDE4"/ $PFP
sed -i s/^.xserver_arguments.*/'xserver_arguments    -audit 0 -deferglyphs 16 -nolisten tcp'/ $PFP
sed -i s/^.default_user.*/"default_user        user"/ $PFP
sed -i s/^auto_login.*/"auto_login          yes"/ $PFP
sed -i s%^console_cmd.*%'console_cmd         /usr/bin/xvt'% $PFP
exit 0
