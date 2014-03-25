%define oname bbswitch

Name:		dkms-bbswitch
Summary:	bbswitch - Optimus GPU power switcher
Version:	0.8
Release:	1
Source0:	%{oname}-%{version}.tar.gz
URL:		https://github.com/Bumblebee-Project/bbswitch
Group:		System/Kernel and hardware
License:	GPLv3
BuildArch:	noarch
Requires:   dkms

%description
bbswitch is a kernel module which automatically detects
the required ACPI calls for two kinds of Optimus laptops. 
It has been verified to work with "real" Optimus and 
"legacy" Optimus laptops (at least, that is how I call them).

%prep
%setup -qn %{oname}-%{version}
sed -i 's/#MODULE_VERSION#/%{version}-%{release}/g' dkms/dkms.conf

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{_usrsrc}/%{oname}-%{version}-%{release}
cp *.c %{buildroot}%{_usrsrc}/%{oname}-%{version}-%{release}
cp Makefile %{buildroot}%{_usrsrc}/%{oname}-%{version}-%{release}
cp dkms/dkms.conf %{buildroot}%{_usrsrc}/%{oname}-%{version}-%{release}/dkms.conf

%post
dkms add -m %{oname} -v %{version}-%{release} --rpm_safe_upgrade &&
dkms build -m %{oname} -v %{version}-%{release} --rpm_safe_upgrade &&
dkms install -m %{oname} -v %{version}-%{release} --rpm_safe_upgrade --force
true
/sbin/modprobe %{oname}

%preun
dkms remove --binary -m %{oname} -v %{version}-%{release} --rpm_safe_upgrade --all
true
/sbin/rmmod %{oname}

%files
%{_usrsrc}/%{oname}-%{version}-%{release}/*

%changelog
* Wed Jan 22 2014 akdengi <kazancas@mandriva.ru> 0.7-1
+ Revision: 714afb6
- update to 0.7


