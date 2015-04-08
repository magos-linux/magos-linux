Summary:        Scripts for nautilus
Name:           fm_scripts
Version:        0.0.2
Release:        %mkrel 1
License:        GPLv3+
URL:            https://github.com/magos-linux/magos-linux/archive/master.zip
Group:          System/Base
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch
#Requires:       magos-scripts

%description
Scripts for dolphin, nautilus

%prep
%setup -q -n %{name}

#%post


%install
mkdir -p %{buildroot}/usr/lib/magos/scripts
mkdir -p %{buildroot}/usr/share/magos/
mkdir -p %{buildroot}/usr/share/kde4/

cp -f ./magos-scripts/*  %{buildroot}/usr/lib/magos/scripts/
cp -fr ./locale/  %{buildroot}/usr/share/magos/
cp -fr ./services %{buildroot}/usr/share/kde4/


%files
/usr/lib/magos/scripts/*
/usr/share/magos/locale/*
/usr/share/kde4/services/*

%changelog
* Fri Nov 28 2014 Mikhail Zaripov <m3for@mail.ru> - 0.0.2
- updated

* Thu Sep 09 2013 betcher <betkher.al@gmail.com>
- initial build
