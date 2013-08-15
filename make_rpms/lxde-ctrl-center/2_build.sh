#!/bin/bash
rm -fr rpmbuild
mkdir -p rpmbuild/SOURCES rpmbuild/SPECS rpms srpms
[ -d ~/rpmbuild ] || ln -s "$PWD/rpmbuild" ~/rpmbuild
cp -p SOURCES/* rpmbuild/SOURCES
cp -p SPECS/* rpmbuild/SPECS
rpmbuild -bs rpmbuild/SPECS/*.spec || exit 1
rpmbuild -bb rpmbuild/SPECS/*.spec || exit 1
find | grep .rpm$ | while read a ;do mv $a rpms ;done
mv rpms/*.src.rpm srpms
echo Done.
