%define	oname	PlayOnLinux

Summary:	Play your Windows games on Linux
Name:		playonlinux
Version:	4.2.1
Release:	2
License:	GPLv3
Group:		Games/Other
Url:		http://www.playonlinux.com
Source0:	http://www.playonlinux.com/script_files/%{oname}/%{version}/%{oname}_%{version}.tar.gz
Source1:	playonlinux.bin
Patch0:		%{oname}_4.0.17-disable-update.patch
Patch1:		%{oname}-4.1.6-disable-GL-checks.patch
Patch2:		%{oname}-4.1.6-use-systemwide-locales-path.patch
Patch3:		%{oname}-4.2.1-fix-desktop-file.patch
BuildRequires:	desktop-file-utils
Requires:	wxPythonGTK
Requires:	imagemagick
Requires:	wget
Requires:	gettext
Requires:	unzip
Requires:	cabextract
Requires:	lzma
Requires:	xterm
Requires:	wine-bin
%if %{mdkversion} > 201000
Requires:	glxinfo
%else
Requires:	mesa-demos
%endif
# for ar
Requires:	binutils
# used to extract icons for applications, otherwise the default icon is used
Suggests:	icoutils >= 0.29
BuildArch:	noarch

%description
PlayOnLinux is a piece of sofware which allows you to install and use easily
numerous games and software designed to run with Microsoft(R)'s Windows(R).
Indeed, currently, still few games are compatible with GNU/Linux, and it could
be a factor preventing from migrating to this system. PlayOnLinux brings an 
accessible and efficient solution to this problem, cost-free and respectful of
the free software.


%prep
%setup -q -n %{name}
# (gvm) Why disable the updgrade notice?
#patch0 -p1
%patch1 -p1
%patch2 -p1
%patch3 -p1

%install
# Prepare the needed dirs
%__mkdir_p %{buildroot}%{_sysconfdir}/xdg/menus/applications-merged
%__mkdir_p %{buildroot}%{_bindir}
%__mkdir_p %{buildroot}%{_datadir}/%{name}
%__mkdir_p %{buildroot}%{_datadir}/desktop-directories
%__mkdir_p %{buildroot}%{_datadir}/applications
%__mkdir_p %{buildroot}%{_datadir}/pixmaps
%__mkdir_p %{buildroot}%{_datadir}/locale

# Add exec perms to files lacking them and kill other rpmlint warnings
chmod +x python/lib/irc.py python/gui_server.py bash/startup_after_server bash/read_pc_cd
chmod +x tests/bash/test-versionlower tests/python/test_versionlower.py

# Copy all in the dest dir
cp -a * %{buildroot}%{_datadir}/%{name}

# Move the needed bits in their right place
%__install -p %{SOURCE1} %{buildroot}%{_bindir}/%{name}
cp etc/*.menu %{buildroot}%{_sysconfdir}/xdg/menus/applications-merged
cp etc/%{oname}.desktop %{buildroot}%{_datadir}/applications/%{oname}.desktop
cp %{buildroot}%{_datadir}/%{name}/etc/%{name}.png %{buildroot}%{_datadir}/pixmaps/%{name}.png
cp %{buildroot}%{_datadir}/%{name}/etc/%{oname}.directory %{buildroot}%{_datadir}/desktop-directories/%{oname}.directory
cp -a lang/locale/* %{buildroot}%{_datadir}/locale/

desktop-file-install \
	--remove-category="%{oname}" \
	--remove-key="Encoding" \
	--dir %{buildroot}%{_datadir}/applications %{buildroot}%{_datadir}/applications/*

# (tpg) useless stuff
%__rm -rf %{buildroot}%{_datadir}/%{name}/bin
%__rm -rf %{buildroot}%{_datadir}/%{name}/src
%__rm -rf %{buildroot}%{_datadir}/%{name}/etc/*.menu
%__rm -rf %{buildroot}%{_datadir}/%{name}/etc/*.desktop
%__rm -rf %{buildroot}%{_datadir}/%{name}/etc/*.directory
rm -rf %{buildroot}%{_datadir}/%{name}/etc/*.applescript
rm -rf %{buildroot}%{_datadir}/%{name}/etc/*.icns
%__rm -rf %{buildroot}%{_datadir}/%{name}/lang
%__rm -rf %{buildroot}%{_datadir}/%{name}/CHANGELOG
%__rm -rf %{buildroot}%{_datadir}/%{name}/playonmac

%find_lang pol

%files -f pol.lang
%doc LICENCE CHANGELOG
%{_sysconfdir}/xdg/menus/applications-merged/%{name}*.menu
%{_bindir}/%{name}
%{_datadir}/%{name}
%{_datadir}/applications/%{oname}.desktop
%{_datadir}/pixmaps/%{name}.png
%{_datadir}/desktop-directories/%{oname}.directory



%changelog
* Tue Mar 26 2013 Giovanni Mariani <mc2374@mclink.it> 4.2-2
- Really fix Requires for wine

* Sun Mar 24 2013 Giovanni Mariani <mc2374@mclink.it> 4.2-1
- New version 4.2

* Mon Jan 21 2013 Giovanni Mariani <mc2374@mclink.it> 4.1.9-1
- New version 4.1.9

* Mon Jul 16 2012 Alexander Khrukin <akhrukin@mandriva.org> 4.1.1-1
+ Revision: 809795
- version update 4.1.1

* Mon Apr 30 2012 Andrey Bondrov <abondrov@mandriva.org> 4.0.18-2
+ Revision: 794582
- Update gl-checks patch to fix POL start in 64 bit OS

* Mon Apr 30 2012 Andrey Bondrov <abondrov@mandriva.org> 4.0.18-1
+ Revision: 794541
- New version 4.0.18

* Mon Apr 30 2012 Andrey Bondrov <abondrov@mandriva.org> 4.0.17-1
+ Revision: 794527
- Don't use %%__cp anymore as it's broken in RPM5 5.4.8
- Copy locales to make find_lang work, make it noarch package (like < 4.0.16)

  + Tomasz Pawel Gajc <tpg@mandriva.org>
    - fix find_lang macro
    - update to new version 4.0.17
    - Patch0: disable info about available updates
    - Patch1: disable check on GL libraries
    - Patch2: search for localisation files on systemwide directory
    - remove lot of useless stuff after the installation
    - provide applications-merged menu
    - make use of %%find_lang

* Thu Mar 22 2012 Andrey Bondrov <abondrov@mandriva.org> 4.0.16-1
+ Revision: 786002
- New version 4.0.16, no longer noarch package

* Thu Dec 15 2011 Alexander Khrukin <akhrukin@mandriva.org> 4.0.14-1
+ Revision: 741674
- version update 4.0.14

* Mon Nov 07 2011 Andrey Bondrov <abondrov@mandriva.org> 4.0.13-2
+ Revision: 723975
- Suggest icoutils - used to extract icons for installed applications

* Sun Nov 06 2011 Andrey Bondrov <abondrov@mandriva.org> 4.0.13-1
+ Revision: 722813
- New version 4.0.13

* Tue Feb 15 2011 Tomasz Pawel Gajc <tpg@mandriva.org> 3.8.8-1
+ Revision: 637862
- update to new version 3.8.8

* Thu Dec 02 2010 Stéphane Téletchéa <steletch@mandriva.org> 3.8.6-1mdv2011.0
+ Revision: 604687
- Update to new version 3.8.6

* Sat Nov 27 2010 Tomasz Pawel Gajc <tpg@mandriva.org> 3.8.5-1mdv2011.0
+ Revision: 601904
- update to new version 3.8.5

* Wed Oct 06 2010 Thierry Vignaud <tv@mandriva.org> 3.8.3-2mdv2011.0
+ Revision: 583153
- require wine-full instead of wine

* Thu Sep 30 2010 Thierry Vignaud <tv@mandriva.org> 3.8.3-1mdv2011.0
+ Revision: 582197
- new release

* Sun Jul 11 2010 Tomasz Pawel Gajc <tpg@mandriva.org> 3.7.6-1mdv2011.0
+ Revision: 550985
- update to new version 3.7.6

  + Ahmad Samir <ahmadsamir@mandriva.org>
    - clean spec and .desktop file

* Mon Mar 01 2010 Tomasz Pawel Gajc <tpg@mandriva.org> 3.7.3-3mdv2010.1
+ Revision: 513266
- require mesa-demos on distributions older than 2010.1
- revert my last commit (use wine instead of wine64 on x86_64)

* Thu Feb 25 2010 Tomasz Pawel Gajc <tpg@mandriva.org> 3.7.3-2mdv2010.1
+ Revision: 510839
- require wine64 on other arch than x86

* Tue Feb 16 2010 Frederik Himpe <fhimpe@mandriva.org> 3.7.3-1mdv2010.1
+ Revision: 506860
- update to new version 3.7.3

* Wed Feb 03 2010 Thierry Vignaud <tv@mandriva.org> 3.7.2-2mdv2010.1
+ Revision: 499986
- requires glxinfo instead of mesa-demos

* Sun Jan 24 2010 Tomasz Pawel Gajc <tpg@mandriva.org> 3.7.2-1mdv2010.1
+ Revision: 495607
- update to new version 3.7.2
- do not remove the LICENCE file (mdvbz #56517)

* Wed Nov 11 2009 Frederik Himpe <fhimpe@mandriva.org> 3.7.1-1mdv2010.1
+ Revision: 464816
- update to new version 3.7.1

* Sun Oct 11 2009 Zombie Ryushu <ryushu@mandriva.org> 3.7-1mdv2010.1
+ Revision: 456673
- Upgrade to 3.7

* Thu Jul 09 2009 Frederik Himpe <fhimpe@mandriva.org> 3.6-1mdv2010.0
+ Revision: 394017
- update to new version 3.6

* Sat May 09 2009 Tomasz Pawel Gajc <tpg@mandriva.org> 3.5-1mdv2010.0
+ Revision: 373869
- update to new version 3.5

* Sat Mar 07 2009 Tomasz Pawel Gajc <tpg@mandriva.org> 3.4-1mdv2009.1
+ Revision: 351817
- update to new version 3.4

* Fri Feb 13 2009 Guillaume Bedot <littletux@mandriva.org> 3.3.1-2mdv2009.1
+ Revision: 340055
- Make pol installable again
- Fix description

* Mon Feb 02 2009 Tomasz Pawel Gajc <tpg@mandriva.org> 3.3.1-1mdv2009.1
+ Revision: 336455
- update to new version 3.3.1

* Mon Jan 26 2009 Tomasz Pawel Gajc <tpg@mandriva.org> 3.3-1mdv2009.1
+ Revision: 333868
- update to new version 3.3

* Mon Dec 29 2008 Tomasz Pawel Gajc <tpg@mandriva.org> 3.2.2-2mdv2009.1
+ Revision: 320803
- rebuild for new python

* Mon Dec 15 2008 Tomasz Pawel Gajc <tpg@mandriva.org> 3.2.2-1mdv2009.1
+ Revision: 314396
- update to new version 3.2.2

* Sun Nov 30 2008 Emmanuel Andry <eandry@mandriva.org> 3.2.1-1mdv2009.1
+ Revision: 308522
- New version (bugfix)

* Sat Nov 29 2008 Tomasz Pawel Gajc <tpg@mandriva.org> 3.2-1mdv2009.1
+ Revision: 308015
- update to new version 3.2

* Tue Nov 11 2008 Emmanuel Andry <eandry@mandriva.org> 3.1.3-1mdv2009.1
+ Revision: 302278
- update to new version 3.1.3

* Mon Oct 20 2008 Tomasz Pawel Gajc <tpg@mandriva.org> 3.1.2-1mdv2009.1
+ Revision: 295743
- update to new version 3.1.2
- fix executable script

* Thu Jul 10 2008 Olivier Blin <blino@mandriva.org> 3.0.8-3mdv2009.0
+ Revision: 233490
- do not untar the main source two times
- improve helper (use sh, do not fork, keep return code)
- python-devel is not required to build
- require wxPythonGTK
- gnome-python-extras/pygtk2.0/python-dbus are not used anymore

* Thu Jul 10 2008 Olivier Blin <blino@mandriva.org> 3.0.8-2mdv2009.0
+ Revision: 233481
- require mesa-demos (for glxinfo)
- require cabextract and lzma
- require binutils for ar

* Thu Jul 03 2008 Tomasz Pawel Gajc <tpg@mandriva.org> 3.0.8-1mdv2009.0
+ Revision: 231165
- update to new version 3.0.8

* Wed Jun 25 2008 Tomasz Pawel Gajc <tpg@mandriva.org> 3.0.7-1mdv2009.0
+ Revision: 228894
- update to new version 3.0.7

* Mon Jun 16 2008 Tomasz Pawel Gajc <tpg@mandriva.org> 3.0.4-1mdv2009.0
+ Revision: 219635
- add source and spec file
- Created package structure for playonlinux. 
