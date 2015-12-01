#!/bin/bash
ZONE=Europe/Moscow

cp -pf /etc/pam.d/system-auth /etc/pam.d/system-auth-default

ln -sf ../tmp /var/tmp
ln -sf /bin/true /sbin/fsck.aufs
ln -sf $(ls boot/vmlinuz-* | tail -1 | sed 's|boot/||') /boot/vmlinuz
ln -sf /usr/share/zoneinfo/$ZONE /etc/localtime
if [ -d /lib64 ] ;then
   ln -sf ../bin64/httpfs /usr/lib/magos/scripts/httpfs
else
   ln -sf ../bin/httpfs /usr/lib/magos/scripts/httpfs
fi

[ -f /sbin/udhcpc ] || ln -s /usr/bin/busybox /sbin/udhcpc
[ -f /sbin/mount.davfs ] || ln -sf /usr/sbin/mount.davfs /sbin/mount.davfs
[ -f /usr/lib/chkpwd/tcb_chkpwd ]   && chown root:shadow usr/lib/chkpwd/tcb_chkpwd   && chmod 2711 usr/lib/chkpwd/tcb_chkpwd
[ -f /usr/lib64/chkpwd/tcb_chkpwd ] && chown root:shadow usr/lib64/chkpwd/tcb_chkpwd && chmod 2711 usr/lib64/chkpwd/tcb_chkpwd

#Default runlevel
[ -f /etc/inittab ] && sed -i s/":3:initdefault:"/":5:initdefault:"/ /etc/inittab

#Realtime settings
PFP=/etc/security/limits.conf
sed -i s/.audio.*rtprio.*/'@audio          -       rtprio           90'/ $PFP
grep -q audio.*memlock $PFP || sed -i /audio.*rtprio/s/$/'\n@audio          -       memlock          unlimited'/ $PFP
sed -i s/.audio.*memlock.*/'@audio          -       memlock          unlimited'/ $PFP

exit 0
