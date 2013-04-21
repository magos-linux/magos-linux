#!/bin/bash
URL=http://abf.rosalinux.ru/downloads/kernels_37x_personal/repository/rosa2012lts/SRPMS/main/release/kernel-3.7.10-1.src.rpm
mkdir -p tmp/content rpmbuild/SOURCES rpmbuild/SPECS
curl -# --retry-delay 2 --retry 5 -o tmp/source.src.rpm $URL || exit 1
cd tmp/content
cat ../source.src.rpm | rpm2cpio - | cpio -i || exit 1
cd ../../
mv tmp/content/* rpmbuild/SOURCES || exit 1
mv rpmbuild/SOURCES/*.spec rpmbuild/SPECS || exit 1
rm -fr tmp
