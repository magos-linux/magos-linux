Summary:        Scripts for dolpuin, konqueror
Name:           fm_scripts
Version:        0.0.3
Release:        %mkrel 1
License:        GPLv3+
URL:            https://github.com/magos-linux/magos-linux/archive/master.zip
Group:          System/Base
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch
#Requires:       dolphin, konqueror
Requires:       dolphin

%description
Scripts for dolphin, konqueror

%prep
%setup -q -n %{name}

#%post


%install
mkdir -p %{buildroot}/usr/lib/magos/scripts
mkdir -p %{buildroot}/usr/share/magos/
mkdir -p %{buildroot}/usr/share/kde4/services

cp -f ./magos-scripts/*  %{buildroot}/usr/lib/magos/scripts/
cp -fr ./locale/  %{buildroot}/usr/share/magos/
cp -fr ./ServiceMenus %{buildroot}/usr/share/kde4/services/


%files
/usr/lib/magos/scripts/*
/usr/share/magos/locale/*
/usr/share/kde4/services/ServiceMenus*

%changelog
* Tue May  5  2015 Alexander Betkher <betcher> <betkher.al@gmail.com> - 0.0.3-1
- some fixes

* Fri Nov 28 2014 Mikhail Zaripov <m3for@mail.ru> - 0.0.2
- updated

* Thu Sep 09 2013 betcher <betkher.al@gmail.com>
- initial build
