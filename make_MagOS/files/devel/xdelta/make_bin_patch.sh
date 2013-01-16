#!/bin/bash
NEWRELEASE=$(ls -1 | grep tar.gz$ | tail -1)
OLDRELEASE=$(ls -1 | grep tar.gz$ | tail -2 | head -1)
[ "$OLDRELEASE" = "$NEWRELEASE" ] && exit 1
NEWVER=$(echo $NEWRELEASE | sed s/.tar.gz// | sed s/^.*_// )
PATCH=$(echo $OLDRELEASE | sed s/.tar.gz/-$NEWVER.tar.gz.upd/)

mkdir -p tmp
mount -o bind tmp /tmp
echo xdelta3 -e -s "$OLDRELEASE" "$NEWRELEASE" "$PATCH"
xdelta3 -e -s "$OLDRELEASE" "$NEWRELEASE" "$PATCH"
umount tmp
rmdir tmp 
#rm -fr tmp
