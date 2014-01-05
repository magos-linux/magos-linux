#!/bin/bash
VER=4.2.18-1
URL=http://mirror.rosalinux.com/rosa/rosa2012.1/repository/SRPMS/main/updates/virtualbox-$VER.src.rpm
if ! [ -d builddeps ] ; then
#FIXME to ignore
   urpmi.removemedia mib
   urpmi.update -a 
   rm -f /var/cache/urpmi/rpms/*
   urpmi --auto --test --noclean dev86 gsoap iasl java-rpmbuild qt4-linguist libcap-devel libstdc++-static-devel openssl-devel pam-devel 'pkgconfig(devmapper)' 'pkgconfig(ext2fs)' 'pkgconfig(gl)' 'pkgconfig(glu)' 'pkgconfig(libcurl)' 'pkgconfig(libIDL-2.0)' 'pkgconfig(libpulse)' 'pkgconfig(libvncserver)' 'pkgconfig(libxslt)' 'pkgconfig(python)' 'pkgconfig(QtCore)' 'pkgconfig(sdl)' 'pkgconfig(xcursor)' 'pkgconfig(xmu)'  'pkgconfig(xinerama)'  'pkgconfig(xorg-server)' 'pkgconfig(xrandr)' 'pkgconfig(xt)' 'pkgconfig(zlib)' || exit 1
   mkdir builddeps
   mv /var/cache/urpmi/rpms/*.rpm builddeps
fi
rpm -Uhv builddeps/*.rpm
mkdir -p tmp/content rpmbuild/SOURCES rpmbuild/SPECS
curl -# --retry-delay 2 --retry 5 -o tmp/source.src.rpm $URL || exit 1
cd tmp/content
cat ../source.src.rpm | rpm2cpio - | cpio -i || exit 1
cd ../../
mv tmp/content/* rpmbuild/SOURCES || exit 1
mv rpmbuild/SOURCES/*.spec rpmbuild/SPECS || exit 1
rm -fr tmp
