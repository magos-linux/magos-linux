#!/bin/bash
PATCH=$(ls -1 | grep tar.gz.upd$ | tail -1)
OLDRELEASE=$(echo $PATCH | sed s/-.*/.tar.gz/ )
NEWVER=$(echo $PATCH | sed s/.tar.gz.upd// | sed s/.*-//)
OLDVER=$(echo $PATCH | sed s/-.*// | sed s/.*_//)
NEWRELEASE=$(echo $OLDRELEASE | sed s/$OLDVER/$NEWVER/)
[ "$OLDRELEASE" = "" -o "$PATCH" = "" -o "$OLDRELEASE" = "$NEWRELEASE" ] && exit 1
[ -f "$OLDRELEASE" ] || exit 1
[ -f "$NEWRELEASE" ] && exit 1
mkdir -p tmp
mount -o bind tmp /tmp
echo xdelta3 -d -s "$OLDRELEASE" "$PATCH" "$NEWRELEASE"
xdelta3 -d -s "$OLDRELEASE" "$PATCH" "$NEWRELEASE"
umount tmp
rmdir tmp
