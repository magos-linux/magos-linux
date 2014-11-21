Summary:        Modules manager for MagOS
Name:           modmnger
Version:        2.0.0
Release:        %mkrel 1
License:        GPLv3+
URL:            https://github.com/magos-linux/magos-linux/archive/master.zip
Group:          System/Base
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch
Requires:       beesu, magos-tools, webkit
#Requires:      magos-scripts

%description
GUI for MagOS utils

%prep
%setup -q -n %{name}

%post

%preun

%install
mkdir -p %{buildroot}%{_datadir}/magos/%{name}
for a in $(ls --hide=locale --hide=desktop ./); do
      cp -rf $a %{buildroot}%{_datadir}/magos/%{name}/
done
mkdir -p %{buildroot}%{_datadir}/locale
cp -fr ./locale/* %{buildroot}%{_datadir}/locale
ln -s %{_datadir}/locale %{buildroot}%{_datadir}/magos/%{name}/locale
mkdir -p %{buildroot}%{_datadir}/pixmaps
mkdir -p %{buildroot}%{_datadir}/applications
mkdir -p %{buildroot}%{_bindir}/
cp -f ./desktop/%{name}.png         %{buildroot}%{_datadir}/pixmaps/
cp -f ./desktop/%{name}.desktop  %{buildroot}%{_datadir}/applications/
cp -f ./desktop/%{name}                %{buildroot}%{_bindir}/
cp -f ./desktop/modinfo                   %{buildroot}%{_bindir}/

%files
%{_datadir}/magos/%{name}/*
%{_datadir}/pixmaps/%{name}.png
%{_datadir}/applications/%{name}.desktop
%{_datadir}/locale
%{_bindir}/%{name}
%{_bindir}/modinfo

%changelog
* Fri Apr 18 2014 betcher <betkher.al@gmail.com>
- initial build
