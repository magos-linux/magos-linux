#!/bin/bash
URL=http://mirror.rosalinux.com/rosa/rosa2012.1/repository/SRPMS/main/updates/systemd-208-28.src.rpm
mkdir -p tmp/content rpmbuild/SOURCES rpmbuild/SPECS
curl -# --retry-delay 2 --retry 5 -o tmp/source.src.rpm $URL || exit 1
cd tmp/content
cat ../source.src.rpm | rpm2cpio - | cpio -i || exit 1
cd ../../
mv tmp/content/* rpmbuild/SOURCES || exit 1
mv rpmbuild/SOURCES/*.spec rpmbuild/SPECS || exit 1

if ! [ -d builddeps ] ; then
#FIXME to ignore
   urpmi.removemedia mib
   urpmi.update -a
   rm -f /var/cache/urpmi/rpms/*
   urpmi --buildrequires --auto --test --no-suggests  --noclean --no-verify-rpm tmp/source.src.rpm || exit 1
   mkdir builddeps
   mv /var/cache/urpmi/rpms/*.rpm builddeps
fi
rpm -Uhv builddeps/*.rpm || exit 1
rm -fr tmp
