#!/bin/bash
URL=http://abf-downloads.rosalinux.ru/kernels_stable_personal/repository/rosa2016.1/SRPMS/kernel_4_19/release/kernel-4.19.72-1.src.rpm
if ! [ -d builddeps ] ; then
   urpmi.update -a
   rm -f /var/cache/urpmi/rpms/*
   urpmi --nofdigests --auto --no-suggests --test --noclean perl-devel numa-devel libunwind-devel kmod-devel kmod-compat gcc bc audit-devel elfutils-devel zlib-devel binutils-devel newt-devel python-devel pciutils-devel flex bison gettext docbook-style-xsl 'perl(ExtUtils::Embed)' 'pkgconfig(gtk+-2.0)' libbzip2-devel lib64slang-devel xmlto asciidoc lib64openssl-devel
   mkdir builddeps
   mv /var/cache/urpmi/rpms/*.rpm builddeps
fi
rpm --nodigest -Uhv builddeps/*.rpm
mkdir -p tmp/content ~/rpmbuild/SOURCES ~/rpmbuild/SPECS
curl -# --retry-delay 2 --retry 5 -o tmp/source.src.rpm $URL || exit 1
cd tmp/content
cat ../source.src.rpm | rpm2cpio - | cpio -i || exit 1
cd ../../
mv tmp/content/* ~/rpmbuild/SOURCES || exit 1
mv ~/rpmbuild/SOURCES/*.spec ~/rpmbuild/SPECS || exit 1
rm -fr tmp
