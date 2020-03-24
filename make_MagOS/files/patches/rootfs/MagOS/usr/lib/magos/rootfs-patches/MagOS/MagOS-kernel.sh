#!/bin/bash
KLIBDIR=/lib/modules
[ -d "$KLIBDIR" ] || KLIBDIR=/usr$KLIBDIR
KERN=$(find "$KLIBDIR" -maxdepth 2 -name modules.dep 2>/dev/null | tail -1 | sed s%/modules.dep%% | awk -F/ '{print $NF}')
KERNSRC=../../../$(find /usr/src -maxdepth 2 -type f -name .config | tail -1  | sed s=/.config==)
[ "$KLIBDIR" = "/usr/lib/modules" ] && KERNSRC=../$KERNSRC
[ -h "$KLIBDIR"/$KERN/build  ] || ln -sf "$KERNSRC" "$KLIBDIR/$KERN/build"
[ -h "$KLIBDIR"/$KERN/source ] || ln -sf "$KERNSRC" "$KLIBDIR/$KERN/source"
ln -sf $(ls -1 /boot/vmlinuz-* | tail -1 | sed 's|/boot/||') /boot/vmlinuz

exit 0
