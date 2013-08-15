Summary:        GPRS connection auto up
Name:           modem_connect
Version:        0.0.1
Release:        %mkrel 1
License:        GPLv3+
URL:		https://github.com/magos-linux/magos-linux/archive/master.zip
Group:          System/Base
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch
Requires:       gnokii, wvdial
#Requires:       magos-scripts
Suggests:       vnstat

%description
Simple scripts to auto up GPRS connection

%prep
%setup -q -n %{name}

%post

%install
mkdir -p  %{buildroot}/etc/udev/rules.d
mkdir -p  %{buildroot}/usr/lib/magos/udev
cp  ./modem_connect  %{buildroot}/usr/lib/magos/udev/
cp  ./shownetstat  %{buildroot}/usr/lib/magos/udev/
cp ./modem.rules  %{buildroot}/etc/udev/rules.d

%files
/etc/udev/rules.d/*
/usr/lib/magos/udev/*

%changelog
* Mon Jun 17 2013 betcher <betkher.al@gmail.com>
- initial build
