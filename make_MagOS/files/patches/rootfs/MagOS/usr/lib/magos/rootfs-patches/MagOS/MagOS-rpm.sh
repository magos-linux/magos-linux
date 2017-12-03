#!/bin/bash

[ -x /bin/rpm ] || exit 0

chmod 444 /var/lib/rpm/modules/*

# tmpfs tweak will increase rpm speed in several times
mkdir /var/lib/rpmbase
mv /var/lib/rpm/* /var/lib/rpmbase
mount -n -t tmpfs tmpfs /var/lib/rpm
mv /var/lib/rpmbase/* /var/lib/rpm

[ -f /var/lib/rpm/pubkeys/magos.pubkey ] && rpm --import /var/lib/rpm/pubkeys/magos.pubkey

cat /var/lib/rpm/modules/81-* | while read a ;do
    rpm -e --nodeps --noscripts --notriggers --justdb ${a%.rpm} 2>/dev/null
done

[ -x /usr/lib/rpm/bin/dbconvert ] && /usr/lib/rpm/bin/dbconvert

rm -fr 2>/dev/null /var/lib/rpm/files-awaiting-filetriggers rpmsoutofbase /var/lib/rpm/__db* /var/lib/rpm/pubkeys

mv /var/lib/rpm/* /var/lib/rpmbase
umount -n /var/lib/rpm
mv /var/lib/rpmbase/* /var/lib/rpm && rmdir /var/lib/rpmbase
exit 0
