#!/bin/bash
PFP=/etc/xdg/plasmarc
[ -f $PFP ] || exit 0
sed -i s/^name=.*/name=magos/ $PFP
PFP=/etc/xdg/kdeglobals
cp -pf /usr/share/magos/plasma/kdeglobals $PFP
sed -i s/^ColorScheme=.*/"ColorScheme=MagOS"/ $PFP
egrep -v "^\[General\]|^Name=|^\[KDE\]|^ColorScheme=|^contrast=|^shadeSortColumn="  "/usr/share/color-schemes/MagOS.colors" >> /etc/xdg/kdeglobals

PFP=/etc/xdg/kscreenlockerrc
cat >$PFP <<EOF
[Daemon]
Autolock=false
LockGrace=300
Timeout=20

[Greeter]
WallpaperPlugin=org.kde.slideshow

[Greeter][Wallpaper][org.kde.slideshow][General]
SlidePaths=/usr/share/magos/screensaver/Default
EOF

PFP=/etc/xdg/ksplashrc
cat >$PFP <<EOF
[KSplash]
Engine=KSplashQML
Theme=org.magos.desktop
EOF

PFP=/etc/xdg/kwinrc
sed -i /^Rows.*/d $PFP
sed -i s/^Number=.*/Number=4\\nRows=2/ $PFP
sed -i s/^Enabled=.*/Enabled=false/    $PFP
cat >>$PFP <<EOF

[Plugins]
blurEnabled=false
contrastEnabled=false
kwin4_effect_fadeEnabled=false
kwin4_effect_loginEnabled=false
kwin4_effect_logoutEnabled=false
kwin4_effect_morphingpopupsEnabled=false
kwin4_effect_translucencyEnabled=false
presentwindowsEnabled=false
screenedgeEnabled=false
slidingpopupsEnabled=false
EOF

PFP=/etc/xdg/klipperrc
cat >>$PFP <<EOF
[General]
SyncClipboards=true
EOF

PFP=/usr/share/plasma/plasmoids/org.kde.plasma.kicker/contents/config/main.xml
sed -i s/rpmdrake.desktop/magos-ctrl-center.desktop/ $PFP

PFP=/usr/share/plasma/plasmoids/org.kde.plasma.kickoff/contents/config/main.xml
sed -i s/rpmdrake.desktop/magos-ctrl-center.desktop/ $PFP

[ -f /usr/bin/kdesu5 -a ! -f /usr/bin/kdesu ] && ln -s kdesu5 /usr/bin/kdesu

PFP=/etc/X11/wmsession.d/01Plasma
if [ -d $(dirname $PFP) ] ;then
  if  [ ! -f $PFP ] ;then
cat >>$PFP <<EOF
NAME=Plasma
DESC=Plasma Desktop
EXEC=/usr/bin/startkde
SCRIPT:
exec /usr/bin/startkde
EOF
[ -x /usr/bin/startplasma ]  && sed -i s/startkde/startplasma/ $PFP
[ -x /usr/bin/startplasma-x11 ]  && sed -i s/startkde/startplasma-x11/ $PFP
[ -x /usr/bin/startplasma-wayland ] && sed -i s/startkde/startplasma-wayland/ $PFP
  fi
fi

PFP=/etc/xdg/kded5rc
cat >>$PFP <<EOF
[Module-device_automounter]
autoload=false
EOF

PFP=/etc/xdg/kded_device_automounterrc
cat >>$PFP <<EOF
[General]
AutomountEnabled=false
AutomountOnLogin=false
AutomountOnPlugin=false
EOF

exit 0
