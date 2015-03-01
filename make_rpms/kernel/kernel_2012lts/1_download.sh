#!/bin/bash
URL=http://abf-downloads.rosalinux.ru/kernels_3_10x_personal/repository/rosa2012.1/SRPMS/main/release/kernel-3.10.63-1.src.rpm
if ! [ -d builddeps ] ; then
#FIXME to ignore
   urpmi.removemedia mib
   urpmi.update -a
   rm -f /var/cache/urpmi/rpms/*
   urpmi --auto --no-suggests --test --noclean numa-devel module-init-tools gcc bc audit-devel elfutils-devel zlib-devel binutils-devel newt-devel python-devel pciutils-devel flex bison gettext docbook-style-xsl 'perl(ExtUtils::Embed)' 'pkgconfig(gtk+-2.0)' libbzip2-devel libslang-devel xmlto asciidoc || exit 1
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
