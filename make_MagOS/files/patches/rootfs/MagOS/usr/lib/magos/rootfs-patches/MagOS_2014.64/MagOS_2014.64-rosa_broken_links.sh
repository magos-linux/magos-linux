#!/bin/sh
if [ -h /usr/share/zoneinfo/posix ] ;then
   rm -f /usr/share/zoneinfo/posix
   mkdir /usr/share/zoneinfo.posix
   ls /usr/share/zoneinfo | while read a ;do
      ln -sf ../$a /usr/share/zoneinfo.posix/$a
   done
   mv /usr/share/zoneinfo.posix /usr/share/zoneinfo/posix
fi

# broken links from rosa-icons package (
rm -f /usr/share/icons/rosa/16x16/devices/chardevice.svg \
  /usr/share/icons/rosa/16x16/emblems/emblem-camera.icon \
  /usr/share/icons/rosa/22x22/emblems/emblem-camera.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-danger.icon \
  /usr/share/icons/rosa/22x22/emblems/emblem-danger.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-desktop.icon \
  /usr/share/icons/rosa/22x22/emblems/emblem-desktop.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-documents.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-favorite.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-important.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-new.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-package.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-people.icon \
  /usr/share/icons/rosa/22x22/emblems/emblem-people.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-personal.icon \
  /usr/share/icons/rosa/22x22/emblems/emblem-personal.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-system.icon \
  /usr/share/icons/rosa/22x22/emblems/emblem-system.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-urgent.icon \
  /usr/share/icons/rosa/16x16/emblems/emblem-video.icon \
  /usr/share/icons/rosa/22x22/mimetypes/gtk-file.icon \
  /usr/share/icons/rosa/22x22/mimetypes/stock_calendar.svg

ln -sf computer.svg /usr/share/icons/rosa/16x16/devices/chardevice.svg
ln -sf ../../24x24/emblems/emblem-camera.icon    /usr/share/icons/rosa/16x16/emblems/emblem-camera.icon
ln -sf ../../24x24/emblems/emblem-camera.icon    /usr/share/icons/rosa/22x22/emblems/emblem-camera.icon
ln -sf ../../24x24/emblems/emblem-danger.icon    /usr/share/icons/rosa/16x16/emblems/emblem-danger.icon
ln -sf ../../24x24/emblems/emblem-danger.icon    /usr/share/icons/rosa/22x22/emblems/emblem-danger.icon
ln -sf ../../24x24/emblems/emblem-desktop.icon   /usr/share/icons/rosa/16x16/emblems/emblem-desktop.icon
ln -sf ../../24x24/emblems/emblem-desktop.icon   /usr/share/icons/rosa/22x22/emblems/emblem-desktop.icon
ln -sf ../../24x24/emblems/emblem-documents.icon /usr/share/icons/rosa/16x16/emblems/emblem-documents.icon
ln -sf ../../24x24/emblems/emblem-favorite.icon  /usr/share/icons/rosa/16x16/emblems/emblem-favorite.icon
ln -sf ../../24x24/emblems/emblem-important.icon /usr/share/icons/rosa/16x16/emblems/emblem-important.icon
ln -sf ../../24x24/emblems/emblem-new.icon       /usr/share/icons/rosa/16x16/emblems/emblem-new.icon
ln -sf ../../24x24/emblems/emblem-package.icon   /usr/share/icons/rosa/16x16/emblems/emblem-package.icon
ln -sf ../../24x24/emblems/emblem-people.icon    /usr/share/icons/rosa/16x16/emblems/emblem-people.icon
ln -sf ../../24x24/emblems/emblem-people.icon    /usr/share/icons/rosa/22x22/emblems/emblem-people.icon
ln -sf ../../24x24/emblems/emblem-personal.icon  /usr/share/icons/rosa/16x16/emblems/emblem-personal.icon
ln -sf ../../24x24/emblems/emblem-personal.icon  /usr/share/icons/rosa/22x22/emblems/emblem-personal.icon
ln -sf ../../24x24/emblems/emblem-system.icon    /usr/share/icons/rosa/16x16/emblems/emblem-system.icon
ln -sf ../../24x24/emblems/emblem-system.icon    /usr/share/icons/rosa/22x22/emblems/emblem-system.icon
ln -sf ../../24x24/emblems/emblem-urgent.icon    /usr/share/icons/rosa/16x16/emblems/emblem-urgent.icon
ln -sf ../../24x24/emblems/emblem-video.icon     /usr/share/icons/rosa/16x16/emblems/emblem-video.icon
ln -sf ../../24x24/mimetypes/gtk-file.icon       /usr/share/icons/rosa/22x22/mimetypes/gtk-file.icon
ln -sf ../../24x24/mimetypes/stock_calendar.svg  /usr/share/icons/rosa/22x22/mimetypes/stock_calendar.svg

exit 0

# show broken links
find usr/share/icons/rosa -type l | while read a ;do [ -f $(readlink -m $a) ] || echo $a ;done | sort | xargs ls -l

