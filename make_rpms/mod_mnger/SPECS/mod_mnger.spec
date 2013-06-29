Summary:        Modules manager for MagOS
Name:           mod_mnger
Version:        0.0.1
Release:        %mkrel 22
License:        GPLv3+
URL:            https://github.com/magos-linux/magos-linux/archive/master.zip
Group:          System/Base
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch
Requires:       tk, magos-scripts, beesu, magos-tools

%description
GUI for activate, deactivate, create and convert MagOS modules

%prep
%setup -q
sed -i -e "s/gksu -g/beesu -l/g" ./%{name}
sed -i -e "s/gksu -g/beesu -l/g" ./mod_maker.tcl

%post
ln -s %{_datadir}/magos/%{name}/%{name} %{_bindir}/%{name}

%preun
if [ $1 -eq 0 ]; then
  rm -f %{_bindir}/%{name}
fi

%install
mkdir -p %{buildroot}%{_datadir}/magos/%{name}
mkdir -p %{buildroot}%{_datadir}/magos/%{name}/msg
cp -f ./*.tcl %{buildroot}%{_datadir}/magos/%{name}/
cp -f ./%{name} %{buildroot}%{_datadir}/magos/%{name}/
cp -f ./msg/*.msg %{buildroot}%{_datadir}/magos/%{name}/msg/
mkdir -p %{buildroot}%{_iconsdir}
cp -f ./module-icon.gif %{buildroot}%{_iconsdir}/
mkdir -p %{buildroot}%{_datadir}/pixmaps
cp -f ./%{name}.png %{buildroot}%{_datadir}/pixmaps/
#install -dm 755 %{buildroot}%{_datadir}/applications
#install -m 0644 %{name}.desktop %{buildroot}%{_datadir}/applications/%{name}.desktop

%files
%doc rus.html
%{_datadir}/magos/%{name}/*
%{_iconsdir}/*.gif
%{_datadir}/pixmaps/%{name}.png
#%{_datadir}/applications/%{name}.desktop

%changelog
* Thu Jun 18 2013 betcher <betkher.al@gmail.com>
- initial build
