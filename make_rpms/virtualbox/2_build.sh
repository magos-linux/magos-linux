#!/bin/bash
mkdir -p rpmbuild/SOURCES rpmbuild/SPECS rpms srpms
[ -d ~/rpmbuild ] || ln -s "$PWD/rpmbuild" ~/rpmbuild
cp -p SOURCES/* rpmbuild/SOURCES
cp -p SPECS/* rpmbuild/SPECS
cd rpmbuild/SPECS
find | egrep '.patch$|.diff$' | while read a ;do
  patch -p1 -i $a || exit 1
done
cd ../../
rpmbuild -bs rpmbuild/SPECS/*.spec || exit 1
rpmbuild -bb rpmbuild/SPECS/*.spec || exit 1
find rpmbuild | grep [.]rpm$ | while read a ;do mv $a rpms ;done
mv rpms/*.src.rpm srpms
