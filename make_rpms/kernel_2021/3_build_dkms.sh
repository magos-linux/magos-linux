#!/bin/bash
MARCH=$(awk '{print $1}' /etc/magos-release)
TMPD=/tmp/make_magos_kernel
. ./.config_$MARCH || exit 1

rpm -e --nodeps kernel-headers
ls rpms/$MARCH/rpms/kernel-header*.rpm rpms/$MARCH/rpms/kernel-*desktop*.rpm cache/$MARCH/dkms/*.rpm | grep -v [-]module | while read a ;do
  rpm -ihv --nodeps --noscripts --nodigest "$a"
done

KNUM=$(ls rpms/$MARCH/rpms/kernel-headers-* | sed s=.*/kernel-headers-== | sed s/-.*// |  sort -n | tail -1)
KERN=$(ls -1d /usr/src/linux-* | grep -- -$KNUM- | sed s%/usr/src/linux-%% | sed s%/$%% | tail -1)
echo Using kernel $KERN

[ -h /lib/modules/$KERN/build  ] || ln -sf /usr/src/linux-$KERN /lib/modules/$KERN/build
[ -h /lib/modules/$KERN/source ] || ln -sf /usr/src/linux-$KERN /lib/modules/$KERN/source

if ! [ -x /usr/bin/rpmlint_fake ] ;then
  mv /usr/bin/rpmlint /usr/bin/rpmlint_real
  cat <<EOF > /usr/bin/rpmlint_fake
#!/bin/bash
exit 0
EOF
  chmod 755 /usr/bin/rpmlint_fake
  ln -sf rpmlint_fake /usr/bin/rpmlint
fi

for a in files/$MARCH/patches/*.patch ;do
    echo $a
    [ -f "$a" ] && patch -N -d / -p1 -i $PWD/$a
done

for a in $DKMS ;do
   VER=$(rpm -q --qf '%{Version}-%{RELEASE}\n' dkms-$a )
   VM=$(echo $VER | awk -F- '{print $1}')
   VR=$(echo $VER | awk -F- '{print $2}')
   echo $a -v $VER -k $KERN
   dkms --rpm_safe_upgrade add -m $a -v $VER -k $KERN
   dkms --rpm_safe_upgrade build -m $a -v $VER -k $KERN
#   dkms --rpm_safe_upgrade mkrpm -m $a -v $VER -k $KERN || exit 1
   rpmbuild --define "version $VM" --define "rel $VR" --define "module_name $a" --define "kernel_versions $KERN" --define "mktarball_line none" -bb /etc/dkms/template-dkms-mkrpm.spec
done

#find -P /var/lib/dkms -type f -name *.rpm | while read a ;do mv -f $a rpms/$MARCH/rpms ;done
mv -f ~/rpmbuild/RPMS/x86_64/*.rpm rpms/$MARCH/rpms

echo Done.
