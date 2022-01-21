#!/bin/bash

[ -x /bin/rpm ] || exit 0

chmod 444 /var/lib/rpm/modules/*

if [ -d /etc/urpmi ] ;then
  sed -i /^\\//d /etc/urpmi/skip.list
  echo -e "/kernel/"\\n"/nvidia/"\\n"/^timezone/" >> /etc/urpmi/skip.list
fi

# tmpfs tweak will increase rpm speed in several times
mkdir -p /var/lib/rpmbase
mv /var/lib/rpm/* /var/lib/rpmbase
mount -n -t tmpfs tmpfs /var/lib/rpm
mv /var/lib/rpmbase/* /var/lib/rpm

[ -f /var/lib/rpm/pubkeys/magos.pubkey ] && rpm --import /var/lib/rpm/pubkeys/magos.pubkey

ls -1 /var/lib/rpm/modules/??-* | sed 's=.*/==' | grep -f "/var/lib/rpm/modules/optional" | sed 's|^|/var/lib/rpm/modules/|' | xargs cat | sort -u | while read a ;do
    rpm -e --nodeps --noscripts --notriggers --justdb ${a%.rpm} 2>/dev/null
done
rm -f /var/lib/rpm/modules/optional

[ -x /usr/lib/rpm/bin/dbconvert ] && /usr/lib/rpm/bin/dbconvert

rm -fr 2>/dev/null /var/lib/rpm/files-awaiting-filetriggers rpmsoutofbase /var/lib/rpm/__db* /var/lib/rpm/pubkeys

mkdir -p /var/lib/rpmbase
mv /var/lib/rpm/* /var/lib/rpmbase
umount -n /var/lib/rpm
mv /var/lib/rpmbase/* /var/lib/rpm && rmdir /var/lib/rpmbase

exit 0
