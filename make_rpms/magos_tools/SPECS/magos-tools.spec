Summary:        MagOS Tools
Name:           magos-tools
Version:        0.0.1
Release:        %mkrel 6
License:        GPLv3+
URL:            https://github.com/magos-linux/magos-linux/archive/master.zip
Group:          System/Base
Source0:        %{name}-%{version}.tar.gz
BuildArch:      noarch
#Requires:       magos-scripts

%description
Tools for MagOS

%prep
%setup -q -n %{name}
sed -i -e "s/gksu -g/beesu -l/g" ./conv4mod
sed -i -e "s/gksu -g/beesu -l/g" ./rpmdrake2lzm

%post
ln -s /usr/lib/magos/scripts/cfg_mnger %{_bindir}/cfg_mnger
ln -s /usr/lib/magos/scripts/conv4mod %{_bindir}/conv4mod
ln -s /usr/lib/magos/scripts/rpmdrake2lzm %{_bindir}/rpmdrake2lzm

%preun
if [ $1 -eq 0 ]; then
  rm -f %{_bindir}/cfg_mnger
  rm -f %{_bindir}/conv4mod
  rm -f %{_bindir}/rpmdrake2lzm
fi

%install
mkdir -p %{buildroot}/usr/lib/magos/scripts
cp -f ./cfg_mnger %{buildroot}/usr/lib/magos/scripts/
cp -f ./conv4mod %{buildroot}/usr/lib/magos/scripts/
cp -f ./rpmdrake2lzm %{buildroot}/usr/lib/magos/scripts/
mkdir -p %{buildroot}%{_datadir}/pixmaps
cp -f ./cfg_mnger.png %{buildroot}%{_datadir}/pixmaps/
cp -f ./conv4mod.png %{buildroot}%{_datadir}/pixmaps/
cp -f ./rpmdrake2lzm.png %{buildroot}%{_datadir}/pixmaps/
#install -dm 755 %{buildroot}%{_datadir}/applications
#install -m 0644 *.desktop %{buildroot}%{_datadir}/applications/

%files
/usr/lib/magos/scripts/*
%{_datadir}/pixmaps/*.png
#%{_datadir}/applications/*.desktop

%changelog
* Thu Jun 18 2013 betcher <betkher.al@gmail.com>
- initial build
