#!/bin/bash
VER=325.15-3
URL=http://mirror.rosalinux.com/rosa/rosa2012.1/repository/SRPMS/non-free/updates/nvidia-current-$VER.src.rpm
if ! [ -d builddeps ] ; then
#FIXME to ignore
   urpmi.removemedia mib
   urpmi.update -a
   rm -f /var/cache/urpmi/rpms/*
   urpmi --auto --test --noclean 'pkgconfig(xrender)' 'pkgconfig(gtk+-2.0)' 'pkgconfig(xv)' 'pkgconfig(vdpau)' libmesagl1-devel libxxf86vm-devel || exit 1
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
