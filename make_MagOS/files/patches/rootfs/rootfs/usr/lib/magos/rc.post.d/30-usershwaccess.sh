#!/bin/bash
ENABLED=yes
[ "$ENABLED" != "yes" ] && exit 0

DEBUGMODE=no
. /liblinuxlive  2>/dev/null || . /mnt/live/liblinuxlive
debug_mode "$0" "$@"

USERGROUPS=audio,video,usb,lp,vboxusers,cdrom
[ -f /etc/sysconfig/MagOS ] && . /etc/sysconfig/MagOS
for a in $(groupmems -l -g users) ;do
   for b in $(echo "$USERGROUPS" | tr ",;" " ") ;do
       usermod -a -G $b $a
   done
done
