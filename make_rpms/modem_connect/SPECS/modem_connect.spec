Summary:        Scripts to auto up 3G modem connection
Name:           modem_connect
Version:        0.0.2
Release:        %mkrel 1
License:        GPLv3+
URL:            https://github.com/magos-linux/magos-linux/archive/master.zip
Group:          System/Base
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch
Requires:       wvdial minicom 
#Requires:       magos-scripts (mdialog)

%description
Scripts for auto up GPRS modem connection

%prep
%setup -q -n %{name}

%post

%install
mkdir -p %{buildroot}/usr/lib/magos/udev/
mkdir -p %{buildroot}/usr/share/magos/
mkdir -p %{buildroot}/etc/udev/
mkdir    %{buildroot}/etc/sysconfig/

cp -fr ./usr  %{buildroot}/
cp -fr ./locale/  %{buildroot}/usr/share/magos/
cp -fr ./rules.d/ %{buildroot}/etc/udev/
cp -f ./modem %{buildroot}/etc/sysconfig
cp -f ./wvdial.sections  %{buildroot}/etc/

%files
/etc/udev/rules.d/*
/usr/share/magos/locale/*
/etc/sysconfig/modem
/etc/wvdial.sections
/usr/lib/magos/scripts/*
/usr/lib/magos/udev/*


%changelog
* Thu Sep 10 2013 betcher <betkher.al@gmail.com>
- initial build
