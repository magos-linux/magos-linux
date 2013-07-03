#!/bin/bash
URL=http://www.kegel.com/wine/winetricks
mkdir -p rpmbuild/SOURCES
curl -# --retry-delay 2 --retry 5 -o rpmbuild/SOURCES/winetricks $URL || exit 1
VERSION=`grep -m1 WINETRICKS_VERSION= rpmbuild/SOURCES/winetricks | sed s/.*=//`
[ -z "$VERSION" ] && exit 1
sed -i s/"Version:.*"/"Version:        $VERSION"/ SPECS/winetricks.spec
grep "Version:" SPECS/winetricks.spec
