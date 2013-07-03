#!/bin/bash
mkdir -p rpmbuild/SOURCES rpmbuild/SPECS rpms srpms
[ -d ~/rpmbuild ] || ln -s "$PWD/rpmbuild" ~/rpmbuild
cp -pf SPECS/* rpmbuild/SPECS
rpmbuild -bs rpmbuild/SPECS/*.spec || exit 1
rpmbuild -bb rpmbuild/SPECS/*.spec || exit 1
find | grep .rpm$ | while read a ;do mv $a rpms ;done
mv rpms/*.src.rpm srpms
echo Done.
