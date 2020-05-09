#!/bin/bash
KLIBDIR=/lib/modules
[ -d "$KLIBDIR" ] || KLIBDIR=/usr$KLIBDIR
for a in "$KLIBDIR"/* ;do
   KVER=$(basename $a)
   [ -f "$a/modules.dep" ] || depmod -a $KVER
   [ -h $a/build ] || ln -sf $(find /usr/src -maxdepth 2 -type d -name *$KVER | head -1) $a/build
   [ -h $a/source ] || ln -sf build $a/source
done
ln -sf $(ls -1 /boot/vmlinuz-* | tail -1 | sed 's|/boot/||') /boot/vmlinuz

exit 0
