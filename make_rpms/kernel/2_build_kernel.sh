#!/bin/bash
MARCH=$(awk '{print $1}' /etc/magos-release)
TMPD=/tmp/make_magos_kernel
. ./.config_$MARCH || exit 1

grep "$HOME/rpmbuild" /proc/mounts | awk '{print $2}' | sort -r | while read a ;do  echo umount "$a" ; umount "$a" 2>/dev/null ; done
rm -fr rpms/"$MARCH"/{rpms,srpms}
mkdir -p ~/rpmbuild/{SOURCES,SPECS,BUILD,BUILDROOT} rpms/$MARCH/{rpms,srpms}

[ -b /dev/zram4 ] || modprobe zram num_devices=5
grep -q /dev/zram4 /proc/mounts && exit 1
echo $((20*1024*1024*1024)) > /sys/block/zram4/disksize
mkfs.ext2 -m0 -F /dev/zram4
mount -o noatime /dev/zram4 ~/rpmbuild
mkdir -p ~/rpmbuild/{SOURCES,SPECS,BUILD,BUILDROOT}

rpm -Uhv --nodeps --nodigest cache/$MARCH/builddeps/*.rpm
rpm -ihv --nodeps --noscripts --nodigest cache/$MARCH/kernel/*.rpm
[ -x /usr/lib/rpm/bin/dbconvert ] && /usr/lib/rpm/bin/dbconvert

cp -pf files/$MARCH/SOURCES/* ~/rpmbuild/SOURCES
if cp -fv files/$MARCH/SPECS/* ~/rpmbuild/SPECS | grep -q . ;then
   MYPATH="$PWD"
   cd ~/rpmbuild/SPECS
   find | egrep '.patch$|.diff$' | sort | while read a ;do
     echo $a
     patch -N -p1 -i $a || exit 1
   done
   cd "$MYPATH"
fi
rpmbuild -bs ~/rpmbuild/SPECS/kernel.spec || exit 1
rpmbuild -bb ~/rpmbuild/SPECS/kernel.spec || exit 1
find ~/rpmbuild | grep .rpm$ | while read a ;do mv $a rpms/$MARCH/rpms ;done
mv rpms/$MARCH/rpms/*.src.rpm rpms/$MARCH/srpms
grep "$HOME/rpmbuild" /proc/mounts | awk '{print $2}' | sort -r | while read a ;do  echo umount "$a" ; umount "$a" 2>/dev/null ; done
