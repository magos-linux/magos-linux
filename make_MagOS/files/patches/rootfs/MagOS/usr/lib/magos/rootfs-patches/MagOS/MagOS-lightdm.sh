#!/bin/bash
PFP=/etc/lightdm/lightdm.conf
if [ -f $PFP ] ;then
   sed -i /^sessions-directory=/d $PFP
   sed -i s%"\[LightDM\]"%"\[LightDM\]\nsessions-directory=/usr/share/xsessions:/usr/share/wayland-sessions"% $PFP
fi

PFP=/etc/lightdm/lightdm-gtk-greeter.conf
if [ -f $PFP ] ;then
   sed -i /^background=/d $PFP
   sed -i /^theme-name=/d $PFP
   sed -i /^default-user-image=/d $PFP
   sed -i s%"\[greeter\]"%"\[greeter\]\ntheme-name=MagOS-Dark\nbackground=/usr/share/magos/wallpapers/default.jpg\ndefault-user-image=/usr/share/faces/default.png"% $PFP
fi

PFP=/lib/systemd/system/lightdm.service
if [ -f $PFP ] ;then
   sed -i s/'^Conflicts=.*'/'Conflicts=getty@tty1.service plymouth-quit.service plymouth-quit-wait.service'/ $PFP
   sed -i s/'^After=.*'/'After=systemd-user-sessions.service getty@tty1.service plymouth-quit.service plymouth-quit-wait.service'/ $PFP
fi

exit 0
