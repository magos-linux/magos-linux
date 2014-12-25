#!/bin/bash
DIRNM=usr/share/apps/plasma/packages/org.kde.stackfolder/contents/ui
[ -d $DIRNM ] || exit 0
for a in Delegate.qml main.qml ;do
    [ -f $DIRNM/$a ] && sed -i /white/d  $DIRNM/$a
done
