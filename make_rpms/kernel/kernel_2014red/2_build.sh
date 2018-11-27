#!/bin/bash
[ -d ~/builddeps ] && rm -fr ~/builddeps
mkdir -p ~/rpmbuild/SOURCES ~/rpmbuild/SPECS ~/rpmbuild/BUILD ~/rpmbuild/BUILDROOT ~/rpmbuild/RPMS rpms srpms
mount -t tmpfs -o size=4G tmpfs ~/rpmbuild/BUILD
mount -t tmpfs -o size=4G tmpfs ~/rpmbuild/BUILDROOT
ln -sf $PWD/rpms ~/rpmbuild/RPMS/i586
ln -sf $PWD/srpms ~/rpmbuild/SRPMS
cp -pf SOURCES/* ~/rpmbuild/SOURCES
if cp -uv SPECS/* ~/rpmbuild/SPECS | grep -q . ;then
   cd ~/rpmbuild/SPECS
   find | egrep '.patch$|.diff$' | sort | while read a ;do
     echo $a
     patch -N -p1 -i $a || exit 1
   done
   cd ../../
fi
rpmbuild -bs ~/rpmbuild/SPECS/kernel.spec || exit 1
rpmbuild -bb ~/rpmbuild/SPECS/kernel.spec || exit 1
umount ~/rpmbuild/BUILD ~/rpmbuild/BUILDROOT
