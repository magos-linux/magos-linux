%global nbmversion 1.6

Name: beesu
Version: 2.7
# Don't ever decrease this version (unless both beesu and nbm update) or the nbm subpackage will go backwards.
# It is easier to do this than to track a separate release field.
Release: 1%{?dist}
Summary: Graphical wrapper for su
URL: http://www.honeybeenet.altervista.org
Group: System/Libraries
License: GPLv2+
Source0: http://honeybeenet.altervista.org/beesu/files/beesu-sources/%{name}-%{version}.tar.bz2
Source1: http://honeybeenet.altervista.org/beesu/files/beesu-manager/nautilus-beesu-manager-%{nbmversion}.tar.bz2
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildRequires: desktop-file-utils
Requires: pam, usermode, usermode-consoleonly

%description
Beesu is a wrapper around su and works with consolehelper under
Fedora to let you have a graphic interface like gksu.

%package -n nautilus-beesu-manager
Version:	%{nbmversion}
BuildArch:	noarch
Requires:	beesu, zenity, nautilus
Group:		Graphical desktop/GNOME
Summary:	Utility to add beesu scripts to nautilus

%description -n nautilus-beesu-manager
nautilus-beesu-manager is a little utility to add some useful scripts
to the Nautilus file browser; nautilus-beesu-manager can add scripts
to Nautilus using beesu to elevate the user's privileges to root.

%prep
%setup -q -a1
chmod -x nautilus-beesu-manager-%{nbmversion}/COPYING nautilus-beesu-manager-%{nbmversion}/README

%build
make CFLAGS="%{optflags} -fno-delete-null-pointer-checks"

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}%{_datadir}/%{name}

make DESTDIR=%{buildroot} install

#nbm
pushd nautilus-beesu-manager-%{nbmversion}
mkdir -v -p %{buildroot}%{_datadir}/icons/hicolor/32x32/apps/
mkdir -v -p %{buildroot}%{_datadir}/applications/
install -p -m 755 nautilus-beesu-manager %{buildroot}%{_bindir}
install -p -m 644 nautilus-beesu-manager.png %{buildroot}%{_datadir}/icons/hicolor/32x32/apps/
desktop-file-install --dir %{buildroot}%{_datadir}/applications --mode 0644 nautilus-beesu-manager.desktop
mkdir -v -p %{buildroot}%{_libexecdir}/nautilus-beesu-manager/
install -p -m 755 libexec/api %{buildroot}%{_libexecdir}/nautilus-beesu-manager/
cp -a libexec/scripts %{buildroot}%{_libexecdir}/nautilus-beesu-manager/
install -p -m 644 libexec/local-launcher %{buildroot}%{_libexecdir}/nautilus-beesu-manager/ 
popd

%clean
rm -rf %{buildroot}

%post -n nautilus-beesu-manager
touch --no-create %{_datadir}/icons/hicolor &>/dev/null || :
update-desktop-database &> /dev/null ||:

%postun -n nautilus-beesu-manager
if [ $1 -eq 0 ] ; then
    touch --no-create %{_datadir}/icons/hicolor &>/dev/null
    if [ -x %{_bindir}/gtk-update-icon-cache ]; then
	gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
    fi
fi
update-desktop-database &>/dev/null || :

%posttrans -n nautilus-beesu-manager
if [ -x %{_bindir}/gtk-update-icon-cache ]; then
    gtk-update-icon-cache %{_datadir}/icons/hicolor &>/dev/null || :
fi


%files
%defattr(-,root,root,-)
%doc COPYING README
%attr(0644,root,root) %config(noreplace) %{_sysconfdir}/%{name}.conf
%attr(0644,root,root) %config(noreplace) %{_sysconfdir}/pam.d/%{name}
%attr(0644,root,root) %config(noreplace) %{_sysconfdir}/security/console.apps/%{name}
%{_sysconfdir}/profile.d/%{name}-bash-completion.sh
%{_sbindir}/%{name}
%{_bindir}/%{name}
%{_mandir}/man1/%{name}.1.xz

%files -n nautilus-beesu-manager
%defattr(-,root,root,-)
%doc nautilus-beesu-manager-%{nbmversion}/COPYING nautilus-beesu-manager-%{nbmversion}/README
%{_bindir}/nautilus-beesu-manager
%{_datadir}/applications/*.desktop
%{_datadir}/icons/hicolor/32x32/apps/nautilus-beesu-manager.png 
%{_libexecdir}/nautilus-beesu-manager/

%changelog
* Wed Apr 17 2013 Mikahil Zaripov <m3for@mail.ru> 2.7-1
- update beesu to 2.7

* Fri Jul  9 2010 Tom "spot" Callaway <tcallawa@redhat.com> 2.6-1
- update beesu to 2.6
- update nautilus-beesu-manager to 1.6

* Wed Feb 24 2010 Tom "spot" Callaway <tcallawa@redhat.com> 2.4-8
- update nautilus-beesu-manager to 1.4
  - one new script to open any file as root with GNOME's associated application

* Thu Aug  6 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.4-7
- fix sources

* Thu Aug  6 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.4-6
- beesu updated to 2.4

* Fri Jul 24 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 2.3-5
- Rebuilt for https://fedoraproject.org/wiki/Fedora_12_Mass_Rebuild

* Mon May 11 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.3-4
- nautilus-beesu-manager update to 1.2
 - one new installable script to change file access
 - new run-once script to fix the access permissions and the 
   file owner on the trash folder

* Thu Apr  9 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.3-3
- fix missing BR: desktop-file-utils

* Thu Apr  9 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.3-2
- enable nautilus-beesu-manager subpackage

* Mon Mar 30 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.3-1
- Update to 2.3

* Mon Feb 23 2009 Fedora Release Engineering <rel-eng@lists.fedoraproject.org> - 2.2-2
- Rebuilt for https://fedoraproject.org/wiki/Fedora_11_Mass_Rebuild

* Fri Feb 13 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.2-1
- Update to 2.2, adds bash auto completion feature

* Thu Jan 29 2009 Tom "spot" Callaway <tcallawa@redhat.com> 2.1-1
- slight package cleanup from Bee

* Fri Nov 28 2008 Bee <http://www.honeybeenet.altervista.org> 2.0-1
- new RPMs for Fedora 10 and some source clean up.

* Mon Oct 27 2008 Bee <http://www.honeybeenet.altervista.org> 1.0-3
- new RPMs

* Wed Oct 15 2008 Bee <http://www.honeybeenet.altervista.org> 1.0-2
- package needs to be arch specific , patch so rpm builds in mock or as non-root & clean up

* Mon Oct 13 2008 Bee <http://www.honeybeenet.altervista.org> 1.0-1
- initial release
