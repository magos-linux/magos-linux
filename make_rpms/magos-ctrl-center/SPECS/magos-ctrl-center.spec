Name: magos-ctrl-center
Version: 0.0.6
Release: 1
Summary: MagOS Control Center
Group: System/Configuration/Other
License: GPLv2+
URL: http://code.google.com/p/lxde-ctrl-center/
Source0: http://code.google.com/p/lxde-ctrl-center/files/%{name}-%{version}.tar.gz
Source1: clouds.png
Source2: bg.png
Source3: magos_tools.svg
Source4: magos_tools
BuildRequires: gettext
Requires: python, pygtk2.0, python-webkitgtk, python-simplejson
Requires: beesu
#Requires: lxde-common
BuildArch: noarch

#drakuser
Suggests: userdrake
#drakauth, drakkeyboard, /usr/sbin/drakscanner, /usr/sbin/diskdrake, /usr/sbin/draksound, drakups, /usr/sbin/drakxservices, draklocale, drakboot, draklog
Suggests: drakxtools-curses
#/usr/sbin/drakguard
Suggests: drakguard
#obconf
Suggests: obconf
#lxappearance
Suggests: lxappearance
#pcmanfm --desktop-pref
Suggests: pcmanfm
#lxrandr
Suggests: lxrandr
#xscreensaver-demo
Suggests: xscreensaver
#drakfont, drakclock
Suggests: drakxtools
#/usr/sbin/harddrake2
Suggests: harddrake-ui
#XFdrake, /usr/sbin/mousedrake
Suggests: drakx-kbd-mouse-x11
#system-config-printer
Suggests: system-config-printer
#mdvinput
Suggests: mdvinput
#pavucontrol
Suggests: pavucontrol
#drakproxy, /usr/sbin/drakfirewall, drakgw
Suggests: drakx-net-text
#vpnpptp
Suggests: vpnpptp-allde
#system-config-nfs
Suggests: system-config-nfs
#system-config-samba
Suggests: system-config-samba
#gigolo
Suggests: gigolo
#drakhosts
Suggests: drakx-net
#drakrpm, drakrpm-edit-media, drakrpm-update
Suggests: rpmdrake
#libfm-pref-apps
Suggests: libfm
#fskbsetting
Suggests: fskbsetting
#/usr/sbin/msecgui
Suggests: msec-gui
#nm-connection-editor
Suggests: networkmanager-applet

%description

MagOS Control Center is united launch tools
for DrakX and MagOS configuration programs.

%prep
%setup -q -n %{name}
mv ./bin/lxde-ctrl-center ./bin/%{name}
mv ./share/lxde-ctrl-center ./share/%{name}
mv ./share/applications/lxde-ctrl-center.desktop ./share/applications/%{name}.desktop
mv ./po/lxde-ctrl-center.pot ./po/%{name}.pot
rm -f ./share/%{name}/items/appearance
for a in ./share/%{name}/control-center.py ./share/%{name}/frontend/css/* ./share/applications/%{name}.desktop \
         ./share/%{name}/frontend/*.html ./share/%{name}/items/* ./bin/* ./scripts/* ./po/* ./translations.py ./make ;do
    sed -i s=lxde-ctrl-center=magos-ctrl-center=g $a
    sed -i s=LXDE=MagOS=g $a
done
for a in ./share/%{name}/control-center.py ./po/magos-ctrl-center.pot ./po/ru.po ./translations.py ;do
    sed -i s=Appearance="MagOS tools"= $a
    sed -i s='Change the background and theme'='Create module'= $a
    sed -i s='Configure visual effects'='Modules Manager'= $a
    sed -i s='Adjust the screen resolution'='Configs Manager'= $a
    sed -i s='Configure Openbox'='Convert modules'= $a
done
sed -i s/"Внешний вид"/"Инструменты MagOS"/ ./po/ru.po
sed -i s/"Смена фона и темы"/"Создание модулей"/ ./po/ru.po
sed -i s/"Настройка визуальных эффектов"/"Управление модулями"/ ./po/ru.po
sed -i s/"Настройка разрешения экрана"/"Управление настройками"/ ./po/ru.po
sed -i s/"Настройка Openbox"/"Преобразование модулей"/ ./po/ru.po

for a in ./scripts/items_advanced.sh ./share/%{name}/control-center.py ./share/%{name}/frontend/*.html ;do
    sed -i s=appearance="magos_tools"=g $a
done
for a in ./share/%{name}/control-center.py ./share/%{name}/frontend/*.html ;do
    sed -i s=change_theme=create_module= $a
    sed -i s=visual_efects=modules_manager= $a
    sed -i s=resolution=configs_manager= $a
done

cp -f %SOURCE1 ./share/%{name}/frontend/images/
cp -f %SOURCE2 ./share/%{name}/frontend/images/
cp -f %SOURCE3 ./share/%{name}/frontend/images/menu/
cp -f %SOURCE4 ./share/%{name}/items/
sed -i -e 's/"beesu drakconnect"/"nm-connection-editor"/g' ./share/%{name}/items/network
sed -i /"OnlyShowIn="/d ./share/applications/%{name}.desktop
sed -i s/Categories=.*/'Categories=X-MandrivaLinux-CrossDesktop;System;'/ ./share/applications/%{name}.desktop

%build
./make build_pkg

%install
mkdir -p %buildroot/%{_datadir}

#sed -i s/Name.ru.=.*/'Name\[ru\]=Центр управления MagOS'/ ./share/applications/%{name}.desktop
#sed -i s/Comment.ru.=.*/'Comment\[ru\]=Центр управления MagOS'/ ./share/applications/%{name}.desktop
cp -rf ./bin %buildroot/usr/
cp -rf ./share/* %buildroot/%{_datadir}

%find_lang %{name}

%files -f %{name}.lang
%doc AUTHORS COPYING
%{_bindir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/javascript/*
%{_datadir}/%{name}

%changelog
* Mon Apr 22 2013 Mikhail Zaripov <m3for@mail.ru> - 0.0.6-1
- modify lxde-ctrl-center to magos-ctrl-center

* Tue Apr 16 2013 AlexL <loginov.alex.valer@gmail.com> - 0.0.6-1
- initial release
- changed bg.png and clouds.png
- used networkmanager-applet instead drakconnect
used networkmanager-applet instead drakconnect

* Tue Apr 16 2013 AlexL <loginov.alex.valer@gmail.com> - 0.0.6-1
- initial release
- changed bg.png and clouds.png
- used networkmanager-applet instead drakconnect
