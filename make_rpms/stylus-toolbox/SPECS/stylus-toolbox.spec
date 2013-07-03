Name:		stylus-toolbox
Version:	0.2.7
Release:	5%{?dist}
Summary:	A printer utility for Epson Stylus® inkjet printers
Group:          System/Printing
License:	GPLv2+
URL:		http://stylus-toolbox.sourceforge.net/
Source0:	http://downloads.sourceforge.net/stylus-toolbox/%{name}-%{version}.tar.bz2
Patch0:		%{name}.patch

BuildArch:	noarch

BuildRequires:	python-devel
Requires:	pexpect
Requires:	pygtk2
Requires:	dbus
Requires:	gutenprint
Requires:	cups

%description
Stylus Toolbox is a printer utility for Epson Stylus® inkjet printers that is
designed to replace the Epson Printer Utility that comes with the Epson drivers
for the Windows platform on Linux, Mac OS X, FreeBSD and other Unix and
Unix-like operating systems that are supported by the Python programming
language and the Gutenprint inkjet drivers.

Stylus Toolbox is a graphical (GUI) front-end for Gutenprint's escputil
command-line Epson printer utility.  As a result, it supports all printers
supported by escputil and Gutenprint, including many recent-model Epson Stylus
and Epson Photo printers. 

%prep
%setup -q
%patch0 -p1

%build

%install
mkdir -p %{buildroot}%{_bindir}
%{__python} setup.py --prefix %{buildroot}/usr
%{__python} setup.py install --root %{buildroot}
sed -i -e 's|%{buildroot}||' %{buildroot}%{_bindir}/%{name}
#remove shebang
sed -i -e '/\/usr\/bin\/env/d' %{buildroot}%{python_sitelib}/GladeWindow.py


%files
%doc README COPYING TODO
%dir %{_datadir}/%{name}
%{_bindir}/%{name}
%{_datadir}/%{name}/*.glade
%{python_sitelib}/*


%changelog
* Fri Feb 15 2013 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.2.7-5
- Rebuilt for https://fedoraproject.org/wiki/Fedora_19_Mass_Rebuild

* Sat Jul 21 2012 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 0.2.7-4
- Rebuilt for https://fedoraproject.org/wiki/Fedora_18_Mass_Rebuild

* Wed Jul 04 2012 Mario Santagiuliana <fedora@marionline.it> - 0.2.7-3
- remove python_sitelib macro

* Wed Jul 04 2012 Mario Santagiuliana <fedora@marionline.it> - 0.2.7-2
- update spec file following Jiri Popelka request:
https://bugzilla.redhat.com/show_bug.cgi?id=772766#c4

* Wed Jan 11 2012 Mario Santagiuliana <fedora@marionline.it> - 0.2.7-1
- update spec file

* Mon Jan 09 2012 Mario Santagiuliana <fedora@marionline.it> - 0.2.7-0
- initial build

