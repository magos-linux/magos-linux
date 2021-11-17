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
#PFP=/lib/systemd/system/sddm.service
#grep -q EnvironmentFile $PFP || sed -i 's|^ExecStart=|EnvironmentFile=/etc/sysconfig/sddm\nExecStart=|' $PFP

mkdir -p /usr/share/xsessions /usr/share/wayland-sessions

if [ ! -f /usr/share/xsessions/default.desktop ] ;then
cat <<EOF >/usr/share/xsessions/default.desktop
[Desktop Entry]
Encoding=UTF-8
Name=DEFAULT
Name[ru]=Сеанс по умолчанию
Comment=Default MagOS Session
Comment[ru]=Предопределённая рабочая среда пользователя
Exec=/usr/share/X11/xdm/Xsession Plasma
Icon=
Type=Application
EOF
fi
[ -f /usr/share/wayland-sessions/default.desktop ] || cp -p /usr/share/xsessions/default.desktop /usr/share/wayland-sessions

if [ -x /usr/bin/i3 ] ;then
  if [ ! /usr/share/xsessions/i3.desktop ] ;then
cat <<EOF >/usr/share/xsessions/i3.desktop
[Desktop Entry]
Name=i3
Comment=improved dynamic tiling window manager
Exec=i3
TryExec=i3
Type=Application
X-LightDM-DesktopName=i3
DesktopNames=i3
Keywords=tiling;wm;windowmanager;window;manager;
EOF
  fi
  [ -f /usr/share/wayland-sessions/i3.desktop ] || cp -p /usr/share/xsessions/i3.desktop /usr/share/wayland-sessions
fi

if [ -x /usr/bin/startlxqt ] ;then
  if [ ! -f /usr/share/xsessions/lxqt.desktop ] ;then
cat <<EOF >/usr/share/xsessions/lxqt.desktop
[Desktop Entry]
Type=Application
Exec=startlxqt
TryExec=lxqt-session
Name=LXQT
Comment=Lightweight Qt Desktop
Name[ru]=LXQt
Comment[ru]=Лёгкий рабочий стол на Qt
EOF
  fi
  [ -f /usr/share/wayland-sessions/lxqt.desktop ] || cp -p /usr/share/xsessions/lxqt.desktop /usr/share/wayland-sessions
fi

if [ ! -f /usr/share/xsessions/plasma.desktop ] ;then
cat <<EOF >/usr/share/xsessions/plasma.desktop
[Desktop Entry]
Type=XSession
Exec=/usr/bin/startkde
TryExec=/usr/bin/startkde
DesktopNames=KDE
Name=Plasma
Name[ru]=Плазма
Comment=Plasma by KDE
Comment[ru]=Плазма от KDE
X-KDE-PluginInfo-Version=5.14.4
EOF
fi
[ -f /usr/share/wayland-sessions/plasma.desktop ] || cp -p /usr/share/xsessions/plasma.desktop /usr/share/wayland-sessions
[ -x /usr/bin/startplasma-wayland ] && sed -i s/startkde/startplasma-wayland/ /usr/share/wayland-sessions/plasma.desktop
[ -x /usr/bin/startplasma-x11 ] && sed -i s/startkde/startplasma-x11/ /usr/share/xsessions/plasma.desktop
[ -x /usr/bin/startplasma ] && sed -i s/startkde/startplasma/ /usr/share/xsessions/plasma.desktop

if [ ! -f /usr/share/xsessions/steam.desktop ] ;then
cat <<EOF >/usr/share/xsessions/steam.desktop
[Desktop Entry]
Type=XSession
Exec=/usr/lib/magos/scripts/startsteam-bp
TryExec=/usr/lib/magos/scripts/startsteam-bp
DesktopNames=Steam
Name=Steam
Name[ru]=Стим
Comment=Steam by Valve
Comment[ru]=Игровой клиент Steam от Valve
EOF
fi
[ -f /usr/share/wayland-sessions/steam.desktop ] || cp -p /usr/share/xsessions/steam.desktop /usr/share/wayland-sessions

exit 0
