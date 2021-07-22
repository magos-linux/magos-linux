#!/bin/bash
MARCH=$(awk '{print $1}' /etc/magos-release)
TMPD=/tmp/make_magos_kernel
. ./.config_$MARCH || exit 1

rpm -e --nodeps --justdb kernel-headers
rpm -ihv --nodeps --noscripts --nodigest rpms/$MARCH/rpms/kernel-header*.rpm
rpm -ihv --nodeps --noscripts --nodigest rpms/$MARCH/rpms/kernel-*desktop*.rpm
rpm -Uhv --nodeps --noscripts --nodigest cache/$MARCH/dkms/*.rpm

KNUM=$(ls rpms/$MARCH/rpms/kernel-headers-* | sed s=.*/kernel-headers-== | sed s/-.*// | sort -n | tail -1)
KERN=$(ls -1d /usr/src/linux-* | grep -- -$KNUM- | sed s%/usr/src/linux-%% | sed s%/$%%)
echo $KERN
[ -h /lib/modules/$KERN/build  ] || ln -sf /usr/src/linux-$KERN /lib/modules/$KERN/build
[ -h /lib/modules/$KERN/source ] || ln -sf /usr/src/linux-$KERN /lib/modules/$KERN/source

if [ "$(readlink -f /usr/bin/rpmlint)" != "/bin/true" ] ;then
  mv /usr/bin/rpmlint /usr/bin/rpmlint.disabled
  ln -sf /bin/true /usr/bin/rpmlint
fi

for a in files/$MARCH/patches/*.patch ;do
    echo $a
    patch -N -d / -p1 -i $PWD/$a
done

for a in $DKMS ;do
   VER=$(rpm -q dkms-$a | sed s%dkms-$a-%% | awk -F- '{print $1 "-" $2}')
   echo $a -v $VER -k $KERN
   dkms --rpm_safe_upgrade add -m $a -v $VER -k $KERN
   dkms --rpm_safe_upgrade build -m $a -v $VER -k $KERN
   dkms --rpm_safe_upgrade mkrpm -m $a -v $VER -k $KERN || exit 1
done

find -P /var/lib/dkms -type f -name *.rpm | while read a ;do mv -f $a rpms/$MARCH/rpms ;done

echo Done.
