#!/bin/bash
NAME="81-libs4primus-$(date +%Y%m%d)"
urpmi.removemedia restricted-release-32
urpmi.removemedia restricted-updates-32
urpmi.removemedia main-release-32
urpmi.removemedia main-updates-32
urpmi.removemedia contrib-release-32
urpmi.removemedia contrib-updates-32
urpmi.removemedia nonfree-release-32
urpmi.removemedia nonfree-updates-32

urpmi.addmedia         restricted-release-32 http://mirror.rosalinux.com/rosa/rosa2014.1/repository/i586/restricted/release
urpmi.addmedia --update restricted-updates-32 http://mirror.rosalinux.com/rosa/rosa2014.1/repository/i586/restricted/updates
urpmi.addmedia          main-release-32 http://mirror.rosalinux.com/rosa/rosa2014.1/repository/i586/main/release
urpmi.addmedia --update main-updates-32 http://mirror.rosalinux.com/rosa/rosa2014.1/repository/i586/main/updates
urpmi.addmedia          contrib-release-32 http://mirror.rosalinux.com/rosa/rosa2014.1/repository/i586/contrib/release
urpmi.addmedia --update contrib-updates-32 http://mirror.rosalinux.com/rosa/rosa2014.1/repository/i586/contrib/updates
urpmi.addmedia          nonfree-release-32 http://mirror.rosalinux.com/rosa/rosa2014.1/repository/i586/non-free/release
urpmi.addmedia --update nonfree-updates-32 http://mirror.rosalinux.com/rosa/rosa2014.1/repository/i586/non-free/updates

urpmi.update -a

rm -fr cache roots  /var/cache/urpmi/rpms/*
mkdir -p cache rootfs/var/lib/rpm/modules
urpmi --auto --test --noclean libgl1 libprimus_gl1
mv /var/cache/urpmi/rpms/* cache

cd rootfs
for a in ../cache/*.rpm ;do
   rpm2cpio $a | cpio -i -d 2>/dev/null || exit 1
done
cd ../

cd cache
ls -1 *.rpm > ../rootfs/var/lib/rpm/modules/$NAME
cd ../

dir2xzm rootfs $NAME.xzm
