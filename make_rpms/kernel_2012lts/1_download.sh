#!/bin/bash
URL=http://abf-downloads.rosalinux.ru/kernels_3_10x_personal/repository/rosa2012lts/SRPMS/main/release/kernel-3.10.12-1.src.rpm
if ! [ -d builddeps ] ; then
#FIXME to ignore
   urpmi.removemedia mib
   urpmi.update -a
   rm -f /var/cache/urpmi/rpms/*
   urpmi --auto --test --noclean elfutils-devel libbzip2-devel binutils-devel libnewt-devel libslang-devel python-devel pciutils-devel bison zlib-devel docbook-style-xsl flex xmlto libgtk+2.0-devel || exit 1
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
