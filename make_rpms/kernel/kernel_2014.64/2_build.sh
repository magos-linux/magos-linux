#!/bin/bash
mkdir -p ~/rpmbuild/SOURCES ~/rpmbuild/SPECS rpms srpms
#[ -d ~/rpmbuild ] || ln -s "$PWD/rpmbuild" ~/rpmbuild
cp -pf SOURCES/* ~/rpmbuild/SOURCES
if cp -uv SPECS/* ~/rpmbuild/SPECS | grep -q . ;then
   cd ~/rpmbuild/SPECS
   find | egrep '.patch$|.diff$' | sort | while read a ;do
     echo $a
     patch -N -p1 -i $a || exit 1
   done
   cd ../../
fi
rpmbuild -bs ~/rpmbuild/SPECS/*.spec || exit 1
rpmbuild -bb ~/rpmbuild/SPECS/*.spec || exit 1
#rpmbuild -bb ~/rpmbuild/SPECS/*.spec > build.log 2>&1 || exit 1
find ~/rpmbuild | grep .rpm$ | while read a ;do mv $a rpms ;done
mv rpms/*.src.rpm srpms
#poweroff