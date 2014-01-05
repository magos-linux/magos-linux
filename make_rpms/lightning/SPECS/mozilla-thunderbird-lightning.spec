%define name    mozilla-thunderbird-lightning
%define version 24.1
%define release %mkrel 1
%define lightning_version 2.6.4

%define lightning_appid \{3550f703-e582-4d05-9a08-453d09bdfdc6\}
%define lightning_extid \{e2fda1a4-762b-4020-b5ad-a41df1933103\}
%define lightning_extdir %{_libdir}/mozilla/extensions/%{lightning_appid}/%{lightning_extid}

Summary:        Calendar extension for Thunderbird
Name: 		%{name}
Version: 	%{version}
Release: 	%{release}
License: 	GPL
Group:          Networking/Mail
URL:            http://www.mozilla.org/projects/calendar/lightning/
Requires:       mozilla-thunderbird >= %{version}
BuildArch: 	noarch
Source0: 	https://addons.cdn.mozilla.net/_files/_attachments/2313/lightning-%{lightning_version}-sm+tb-linux.xpi
BuildRoot: 	%{_tmppath}/%{name}-%{version}-%{release}-buildroot

%description
Calendar extension for Thunderbird. All languages are included.

%prep
%setup -q -c -T
unzip -qq %{SOURCE0}

%build
# All install.rdf files must validate
#xmllint --noout */install.rdf

%install
rm -rf %buildroot
rm -fr components/Linux_x86_64-gcc3
mkdir -p %buildroot%{lightning_extdir}
cp -f -r * %buildroot%{lightning_extdir}

%clean
rm -rf %buildroot

%files
%defattr(644,root,root,755)
%{lightning_extdir}

%changelog
* Tue Apr 16 2013 Mikahil Zaripov <m3for@mail.ru> 17.0-2
- update to 2.6.4

* Tue Apr 16 2013 Mikahil Zaripov <m3for@mail.ru> 17.0-2
- update to 1.9.1

* Tue Jan 01 2013 Mikahil Zaripov <m3for@mail.ru> 17.0-1
- initial release
