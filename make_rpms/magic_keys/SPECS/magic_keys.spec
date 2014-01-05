Summary:        MagOS magic keys
Name:           magic_keys
Version:        0.0.1
Release:        %mkrel 1
License:        GPLv3+
URL:            https://github.com/magos-linux/magos-linux/archive/master.zip
Group:          System/Base
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch
Requires:       xbindkeys, xkill, rfkill, recordmydesktop, xclip
#Requires:       magos-scripts

%description
MagOS-linux hotkeys

%prep
%setup -q -n %{name}

%post


%install
mkdir -p %{buildroot}/usr/lib/magos/scripts
mkdir -p %{buildroot}/etc/skel
mkdir -p %{buildroot}/usr/share/magos/
cp -f ./keyscripts  %{buildroot}/usr/lib/magos/scripts/
cp -fr ./locale/  %{buildroot}/usr/share/magos/
cp -f ./.??* %{buildroot}/etc/skel/


%files
/etc/skel/.xbindkeysrc
/etc/skel/.mykeys
/usr/lib/magos/scripts/keyscripts
/usr/share/magos/locale/*

%changelog
* Thu Sep 06 2013 betcher <betkher.al@gmail.com>
- initial build
