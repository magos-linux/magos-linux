Name: lxde-ctrl-center
Version: 0.1.2
Release: 1
Summary: LXDE Control Center
Group: System/Configuration/Other
License: GPLv3+
URL: http://code.google.com/p/lxde-ctrl-center
Source0: http://code.google.com/p/lxde-ctrl-center/files/%{name}-%{version}.tar.gz
Source1: clouds.png
Source2: bg.png
BuildRequires: gettext
BuildRequires: python
#BuildRequires: python-simplejson
Requires: python
Requires: pygtk2.0
Requires: python-webkitgtk
Requires: python-simplejson
Requires: beesu
Requires: lxde-common
BuildArch: noarch

#drakuser
Suggests: userdrake
#drakauth, drakkeyboard, drakscanner, diskdrake, draksound, drakups, drakxservices, draklocale, drakboot, draklog, drakedm
Suggests: drakxtools-curses
#drakguard
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
#drakfont, drakclock, draksec
Suggests: drakxtools
#harddrake2
Suggests: harddrake-ui
#XFdrake, mousedrake
Suggests: drakx-kbd-mouse-x11
#system-config-printer
Suggests: system-config-printer
#mdvinput
Suggests: mdvinput
#pavucontrol
Suggests: pavucontrol
#drakproxy, drakfirewall, drakgw
Suggests: drakx-net-text
#vpnpptp
Suggests: vpnpptp
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
#msecgui
Suggests: msec-gui
#nm-connection-editor
Suggests: networkmanager-applet
#add2sudoers, rmfromsudoers
Suggests: xsudo-sudoers
#xdg-open
Suggests: xdg-utils
#CUPS Web Interface
Suggests: cups

%description
LXDE Control Center is united launch tools for DrakX
and LXDE configuration programs.

%prep
%setup -q -n %{name}
cp -f %{SOURCE1} ./share/%{name}/frontend/images/
cp -f %{SOURCE2} ./share/%{name}/frontend/images/
sed -i -e 's/"beesu drakconnect"/"nm-connection-editor"/g' ./share/%{name}/items/x0002x
sed -i -e '/"beesu drakgw"/d' ./share/%{name}/items/x0002x
sed -i s/Categories=.*/'Categories=X-MandrivaLinux-CrossDesktop;System;'/ ./share/applications/%{name}.desktop

%build
./make build_pkg

%install
mkdir -p %{buildroot}/%{_datadir}
cp -rf ./bin %{buildroot}/%{_prefix}/
cp -rf ./share/* %{buildroot}/%{_datadir}

%find_lang %{name}

%files -f %{name}.lang
%doc AUTHORS COPYING
%{_bindir}/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/%{name}
