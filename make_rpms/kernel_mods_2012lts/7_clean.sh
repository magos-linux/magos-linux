#!/bin/bash
rmdir ftp
rm -fr rpms cache
for a in dkms/* ;do
   echo $a
   . $a/.config || exit 1
   rpm -e --noscripts dkms-$MOD
done
[ -h ~/rpmbuild -a ! -d ~/rpmbuild ] && rm -f ~/rpmbuild
if [ -x /usr/bin/rpmlint.disabled ] ;then
   rm -f /usr/bin/rpmlint
   mv /usr/bin/rpmlint.disabled /usr/bin/rpmlint
fi
echo Done.
