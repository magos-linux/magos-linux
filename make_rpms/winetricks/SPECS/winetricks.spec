Summary:	wine helper script
Name:		winetricks
Version:        20130707
Release:	1
License:	GPLv2
Group:		Games/Other
Url:		http://winetricks.org/
Source0:	http://winetricks.org/winetricks
Requires:	wine
BuildArch:	noarch

%description
Winetricks is a helper script to download and install various redistributable 
runtime libraries needed to run some programs in Wine. These may include
replacements for components of Wine using closed source libraries.

%prep

%install
mkdir -p %{buildroot}%{_bindir}
cp %{SOURCE0} %{buildroot}%{_bindir}
chmod +x %{buildroot}%{_bindir}/%{name}

%files
%{_bindir}/%{name}

%changelog
* Wed Jul 03 2013 Mikhail Zaripov<m3for@mail.ru>
- Initial release for magos-linux

