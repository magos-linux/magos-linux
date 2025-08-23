#!/bin/bash
NUM="51-x"
NAME="openmw_vr"
VERSION=0.49
. ../functions || exit 1

SRCURL=http://ftp.magos-linux.ru/rpms/2021/
SUFF=-rosa2021.x86_64.rpm
SOURCELIST="openmw-0.49.0-2vr lib64openxr-1.0.24-2vr collada-dom-2.5.0-1 lib64luajit-5.1-common-2.1-git20250816 lib64luajit-5.1_2-2.1-git20250816 \
lib64mygui3-3.4.3-4 lib64recastnavigation-1.6.0-1 mygui-3.4.3-4 openscenegraph-plugins-3.6.5-4omw \
lib64OpenThreads21-3.6.5-4omw lib64osg162-3.6.5-4omw lib64osgAnimation162-3.6.5-4omw lib64osgDB162-3.6.5-4omw lib64osgFX162-3.6.5-4omw \
lib64osgGA162-3.6.5-4omw lib64osgManipulator162-3.6.5-4omw lib64osgParticle162-3.6.5-4omw lib64osgPresentation162-3.6.5-4omw \
lib64osgParticle162-3.6.5-4omw lib64osgQt145-3.6.5-4omw lib64osgShadow162-3.6.5-4omw lib64osgSim162-3.6.5-4omw lib64osgTerrain162-3.6.5-4omw \
lib64osgText162-3.6.5-4omw lib64osgUI162-3.6.5-4omw lib64osgUtil162-3.6.5-4omw lib64osgViewer162-3.6.5-4omw lib64osgVolume162-3.6.5-4omw lib64osgWidget162-3.6.5-4omw"
DNFINST="ogre lib64Qt6OpenGLWidgets lib64Qt6Svg lib64SDL2_image2.0_0 lib64rhash0 lib64unshield0 lib64uriparser1 lib64yaml-cpp0.6"

clean

prepare

mkdir -p rootfs/var/lib/rpm/modules cache
cd cache
echo "$SOURCELIST" | tr ' ' "\\n" | while read p ;do
    [ -z "$p" ] ||  download $SRCURL$p$SUFF
done

cd ..
[ ! -z "$DNFINST" ] && dnf -y --downloadonly --skip-broken --destdir cache install $DNFINST || exit 1
rsync -a --delete cache/ $CACHE || exit 1

cd rootfs
for a in $CACHE/*.rpm ;do
   rpm2cpio $a | cpio -i -d 2>/dev/null || exit 1
done
ls -1 $CACHE/*.rpm | sed 's|.*/||' > var/lib/rpm/modules/$NUM-$NAME
cd ../

pack rootfs $(dirname $DIRNAME)/$NUM-$NAME-$VERSION

clean
